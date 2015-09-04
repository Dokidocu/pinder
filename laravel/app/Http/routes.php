<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the controller to call when that URI is requested.
|
*/

// Register a new user and return his JWT token
Route::post('/signup', 'Auth\TokenAuthController@signup');
// Get a token for an email/password
Route::post('/signin', 'Auth\TokenAuthController@signin');
// Get a new token from an invalid token
Route::get('/refresh', 'Auth\TokenAuthController@refresh');
// Invalidate a token
Route::get('/signout', 'Auth\TokenAuthController@signout');
// Test if a user is authenticated
Route::get('/test', 'Auth\TokenAuthController@test');

// Only allow authed users to access the API v0, checked with the JWT plugin
Route::group(['prefix' => 'v0', 'middleware' => ['jwt.auth']], function(){
//Route::group(['prefix' => 'v0'], function(){

    Route::get('/', function()
    {
        return 'Hello v0 World';
    });

    Route::get('question', 'QuestionController@get');
    Route::get('question/new', 'QuestionController@newQuestions');
    Route::get('question/{id}', 'QuestionController@get');
    Route::post('question/{id}', 'QuestionController@post');
    /**
     * Add new question
     * text: string
     * theme_id: integer
     * response: nullable boolean
     *
     */
    Route::post('question', 'QuestionController@post');

    Route::get('theme', 'ThemeController@get');
    Route::get('party', 'PartyController@get');


});

