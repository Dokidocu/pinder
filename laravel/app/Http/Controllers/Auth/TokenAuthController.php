<?php namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Contracts\Auth\Guard;
use Illuminate\Contracts\Auth\Registrar;
use Illuminate\Foundation\Auth\AuthenticatesAndRegistersUsers;
use JWTAuth;
use Tymon\JWTAuth\Exceptions\JWTException;
use Input;
use Validator;
use App\User;
use App\Role;
use App\LocalBrand;
use App\Favorite;
use App\PhoneValidation;
use Carbon\Carbon;
use Twilio;
use DB;


class TokenAuthController extends Controller {


    /**
     * Create a new authentication controller instance.
     *
     * @param  \Illuminate\Contracts\Auth\Guard  $auth
     * @param  \Illuminate\Contracts\Auth\Registrar  $registrar
     * @return void
     */
    public function __construct()
    {

    }

    public function signup()
    {
        //$nextYear = time() + (7 * 24 * 60 * 60 * 52);

        //$customClaims = ['exp' => $nextYear];
        $credentials = Input::only('email', 'password');

        $validator = Validator::make(
            $credentials,
            [
                'email' => ['required', 'email'],
                'password' => ['required'],
            ]
        );

        if ($validator->fails())
        {

            // The given data did not pass validation
            return response()->json(['error' => 'invalid_data'], 400);
        }

        try
        {
            $user = User::create($credentials);
        }
        catch (Exception $e)
        {
            // HttpResponse::HTTP_CONFLICT = 409
            return response()->json(['error' => 'user_already_exists'], 409);
        }

        try
        {
            $token = JWTAuth::fromUser($user);
        }
        catch (JWTException $e)
        {
            // something went wrong whilst attempting to encode the token
            return response()->json(['error' => 'could_not_create_token'], 500);
        }

        return response()->json(compact('token'));
    }

    public function signin()
    {
        $credentials = Input::only('email', 'password');
        try
        {
            // attempt to verify the credentials and create a token for the user
            if (! $token = JWTAuth::attempt($credentials))
            {
                return response()->json(['error' => 'invalid_credentials'], 401);
            }

        }
        catch (JWTException $e)
        {
            // something went wrong whilst attempting to encode the token
            return response()->json(['error' => 'could_not_create_token'], 500);
        }

        // all good so return the token
        return response()->json(compact('token'));
    }

    public function refresh()
    {
        try
        {
            $token = JWTAuth::getToken();
            $refreshed_token = JWTAuth::refresh($token);
        }
        catch (Tymon\JWTAuth\Exceptions\TokenBlacklistedException $e)
        {
            return response()->json(['error' => 'token_blacklisted'], $e->getStatusCode());
        }
        catch (Tymon\JWTAuth\Exceptions\TokenExpiredException $e)
        {
            return response()->json(['error' => 'token_expired'], $e->getStatusCode());
        }
        catch (Tymon\JWTAuth\Exceptions\TokenInvalidException $e)
        {
            return response()->json(['error' => 'token_invalid'], $e->getStatusCode());
        }
        catch (Tymon\JWTAuth\Exceptions\JWTException $e)
        {
            return response()->json(['error' => 'token_absent'], $e->getStatusCode());
        }

        // all good so return refreshed the token
        return response()->json(['token'=>$refreshed_token]);
    }

    public function signout()
    {
        try
        {
            $token = JWTAuth::getToken();
            $token = JWTAuth::invalidate($token);
            return response()->json(['result' => 'user_signed_out'], 200);
        }
        catch (Tymon\JWTAuth\Exceptions\TokenBlacklistedException $e)
        {
            return response()->json(['error' => 'token_blacklisted'], $e->getStatusCode());
        }
        catch (Tymon\JWTAuth\Exceptions\TokenExpiredException $e)
        {
            return response()->json(['error' => 'token_expired'], $e->getStatusCode());
        }
        catch (Tymon\JWTAuth\Exceptions\TokenInvalidException $e)
        {
            return response()->json(['error' => 'token_invalid'], $e->getStatusCode());
        }
        catch (Tymon\JWTAuth\Exceptions\JWTException $e)
        {
            return response()->json(['error' => 'token_absent'], $e->getStatusCode());
        }
    }

    public function test()
    {
        try
        {
            $token = JWTAuth::getToken();
            $user = JWTAuth::parseToken()->authenticate();
            $message = 'Hello ' . $user->email;
            return response()->json(['result' => $message], 200);
        }
        catch (Tymon\JWTAuth\Exceptions\TokenBlacklistedException $e)
        {
            return response()->json(['error' => 'token_blacklisted'], $e->getStatusCode());
        }
        catch (Tymon\JWTAuth\Exceptions\TokenExpiredException $e)
        {
            return response()->json(['error' => 'token_expired'], $e->getStatusCode());
        }
        catch (Tymon\JWTAuth\Exceptions\TokenInvalidException $e)
        {
            return response()->json(['error' => 'token_invalid'], $e->getStatusCode());
        }
        catch (Tymon\JWTAuth\Exceptions\JWTException $e)
        {
            return response()->json(['error' => 'token_absent'], $e->getStatusCode());
        }
    }

}
