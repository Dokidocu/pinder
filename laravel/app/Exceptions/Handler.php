<?php

namespace App\Exceptions;

use Exception;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Symfony\Component\HttpKernel\Exception\HttpException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;

class Handler extends ExceptionHandler
{
    /**
     * A list of the exception types that should not be reported.
     *
     * @var array
     */
    protected $dontReport = [
        HttpException::class,
        ModelNotFoundException::class,
    ];

    /**
     * Report or log an exception.
     *
     * This is a great spot to send exceptions to Sentry, Bugsnag, etc.
     *
     * @param  \Exception  $e
     * @return void
     */
    public function report(Exception $e)
    {
        return parent::report($e);
    }

    /**
     * Render an exception into an HTTP response.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Exception  $e
     * @return \Illuminate\Http\Response
     */
    public function render($request, Exception $e)
    {
        if ($e instanceof ModelNotFoundException) {
            $e = new NotFoundHttpException($e->getMessage(), $e);
        }

        if ($request->ajax())
        {
            if($e instanceof ModelNotFoundException)
            {
                return response()->json(['error'=>'resource_does_not_exist'], 400);
            }
            else if($e instanceof QueryException)
            {
                if($e->errorInfo[0] === '23000')
                {
                    //print $e->getMessage();
                    //print_r($e->errorInfo);
                    return response()->json(['error'=>"duplicate_entry"], 409, [], $options=JSON_PRETTY_PRINT);
                }
                else
                {
                    //print_r($e->errorInfo);
                    return response()->json(['error'=>'query_exception'], 400);
                }
            }
            else if($e instanceof Exception)
            {
                return response()->json(['error'=>$e->getMessage()], 400);
            }
        }

        return parent::render($request, $e);
    }
}
