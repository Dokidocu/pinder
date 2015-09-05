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
            $table->dateTime('birthday');
            $table->integer('postcode');
            $table->string('gender');
            $table->rememberToken();
            $table->timestamps();
        });

        Schema::create('questions', function (Blueprint $table) {
            $table->increments('id');
            $table->string('title');
            $table->string('text');
            $table->string('author');
            $table->string('source');
            $table->string('link');
            $table->string('ends_at')->nullable()->default(null);
            $table->timestamps();
        });

        Schema::create('themes', function (Blueprint $table) {
            $table->increments('id');
            $table->string('name');
            $table->timestamps();
        });

        Schema::create('question_theme', function(Blueprint $table)
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

        Schema::create('user_party', function(Blueprint $table)
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
            $table->integer('question_id')->unsigned();
            $table->integer('user_id')->unsigned();
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users');
            $table->foreign('question_id')->references('id')->on('questions');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('question_theme');
        Schema::drop('user_party');
        Schema::drop('users');
        Schema::drop('questions');
        Schema::drop('themes');
        Schema::drop('parties');
        Schema::drop('answers');

    }
}
