<?php

namespace App\Http\Controllers;

use App\Question;
use App\Answer;
use App\Theme;
use App\Http\Controllers\Controller;
use JWTAuth;
use Input;
use Validator;

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

        })->where('answers.id', '=', null)
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
        $user = JWTAuth::parseToken()->toUser();
        $data = Input::only('text', 'theme', 'answer');
        $validator = Validator::make(
            $data, [
                'text' => 'string|required',
                'theme' => 'integer',
                'answer' => 'string',
            ]
        );

        if ($validator->fails())
        {
            return response()->json(['error' => 'invalid_data', 'message'=>'text is required'], 400);
        }

        $question = Question::create([
            'text' => $data['text'],
            'source' => 'app',
            'author' => $user->id,
        ]);

        if (Input::has('theme'))
        {
            $myTheme = Theme::find(integerValue($data['theme']));
            $question->themes()->attach($myTheme->id);
        }

        if (Input::has('answer'))
        {
            $answer = Answer::create([
                'answer' => $data['answer'],
                'user_id' => $user->id,
                'question_id' => $question->id,
            ]);
        }

        return response()->json(['result'=>$question], 200);
    }

    private function addAnswer($questionId)
    {
        $user = JWTAuth::parseToken()->toUser();
        $data = Input::only('answer');
        $validator = Validator::make(
            $data, [
                'answer' => 'string|required',
                ]
        );

        if ($validator->fails())
        {
            return response()->json(['error' => 'invalid_data', 'message'=>'answer is required'], 400);
        }

        $answer = Answer::create([
            'answer' => $data['answer'],
            'user_id' => $user->id,
            'question_id' => $questionId,
        ]);

        return response()->json(['result'=>$answer], 200);
    }
}