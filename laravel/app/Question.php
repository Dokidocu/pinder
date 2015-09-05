<?php

namespace App;

use Illuminate\Auth\Authenticatable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Auth\Passwords\CanResetPassword;
use Illuminate\Foundation\Auth\Access\Authorizable;
use Illuminate\Contracts\Auth\Authenticatable as AuthenticatableContract;
use Illuminate\Contracts\Auth\Access\Authorizable as AuthorizableContract;
use Illuminate\Contracts\Auth\CanResetPassword as CanResetPasswordContract;

class Question extends Model
{
    /**
     * The database table used by the model.
     *
     * @var string
     */
    protected $table = 'questions';

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = ['text', 'title', 'author', 'source', 'link', ];

    /**
     * The attributes excluded from the model's JSON form.
     *
     * @var array
     */
    //protected $hidden = ['password', 'remember_token'];

    public function themes()
    {
        return $this->belongsToMany('App\Theme', 'question_theme', 'question_id', 'theme_id')->withTimestamps();
    }

    public function answers()
    {
        return $this->hasMany('App\Answer', 'question_id');
    }

    public function yesCount()
    {
        return $this->hasOne('App\Answer', 'question_id')
            ->selectRaw('question_id, count(*) as yes_count')
            ->where('answer', '=', 'YES')
            ->groupBy('question_id');
    }

    public function noCount()
    {
        return $this->hasOne('App\Answer', 'question_id')
            ->selectRaw('question_id, count(*) as no_count')
            ->where('answer', '=', 'NO')
            ->groupBy('question_id');
    }
}
