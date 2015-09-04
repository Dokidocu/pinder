<?php

use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateUsersTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('users', function (Blueprint $table) {
            $table->increments('id');
            $table->string('name');
            $table->string('email')->unique();
            $table->string('password', 60);
            $table->rememberToken();
            $table->timestamps();
        });

        Schema::create('questions', function (Blueprint $table) {
            $table->increments('id');
            $table->string('title');
            $table->string('text');
            $table->string('ends_at');
            $table->timestamps();
        });

        Schema::create('themes', function (Blueprint $table) {
            $table->increments('id');
            $table->string('name');
            $table->timestamps();
        });

        Schema::create('questions_themes', function(Blueprint $table)
        {
            $table->increments('id');
            $table->integer('question_id')->unsigned();
            $table->integer('theme_id')->unsigned();

            // Adds a delete date instead of actually deleting a row
            $table->softDeletes();
            // Adds creted and modified fields
            $table->timestamps();

            $table->foreign('theme_id')->references('id')->on('themes');
            $table->foreign('question_id')->references('id')->on('questions');
        });

        Schema::create('parties', function (Blueprint $table) {
            $table->increments('id');
            $table->string('name');
            $table->timestamps();
        });

        Schema::create('users_parties', function(Blueprint $table)
        {
            $table->increments('id');
            $table->integer('user_id')->unsigned();
            $table->integer('party_id')->unsigned();

            // Adds a delete date instead of actually deleting a row
            $table->softDeletes();
            // Adds created and modified fields
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users');
            $table->foreign('party_id')->references('id')->on('parties');
        });

        Schema::create('answers', function (Blueprint $table) {
            $table->increments('id');
            $table->string('answer');
            $table->integer('user_id')->unsigned();
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('questions_themes');
        Schema::drop('users_parties');
        Schema::drop('users');
        Schema::drop('questions');
        Schema::drop('themes');
        Schema::drop('parties');
        Schema::drop('answers');

    }
}
