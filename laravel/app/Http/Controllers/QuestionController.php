<?php

namespace App\Http\Controllers;

use App\Question;
use App\Answer;
use App\Http\Controllers\Controller;

class QuestionController extends Controller
{
    /**
     * Show the profile for the given user.
     *
     * @param  int  $id
     * @return Response
     */
    public function get($id = null)
    {
        if($id != null)
        {
            return response()->json(['error'=>'not_implemented'], 403);
        }

        $user = JWTAuth::parseToken()->toUser();

        // Questions that the user has already answered
        $questions = Question::select('questions.*')->join('answers', function($join) use ($user)
        {
            $join->on('questions.id', '=', 'answers.question_id')->where('answers.user_id', '=', $user->id);

        })->get();

        return response()->json(['result'=>$questions]);
    }

    public function newQuestions()
    {
        $user = JWTAuth::parseToken()->toUser();

        // Questions that the user hasn't answered yet (first 20)
        $questions = Question::select('questions.*')->leftJoin('answers', function($join) use ($user)
        {
            $join->on('questions.id', '=', 'answers.question_id')->where('answers.user_id', '=', $user->id);

        })->whereIsNull('answers.id')
        ->get();

        return response()->json(['result'=>$questions]);
    }

    public function post($id = null)
    {
        if($id !== null)
        {
            return $this->addAnswer($id);
        }
        else
        {
            return $this->addQuestion();
        }
    }

    private function addQuestion()
    {
        return response()->json(['error'=>'not_implemented'], 403);
    }

    private function addAnswer($id)
    {
        $user = JWTAuth::parseToken()->toUser();
        $data = Input::only('answer');
        $validator = Validator::make(
            $data, [
                'answer' => 'string',
                ]
        );

        if ($validator->fails())
        {
            return response()->json(['error' => 'invalid_data', 'message'=>'answer is required'], 400);
        }

        $answer = Answer::create([
            'answer' => $data['answer'],
            'user_id' => $user->id,
        ]);

        return response()->json(['result'=>$answer], 200);
    }
}