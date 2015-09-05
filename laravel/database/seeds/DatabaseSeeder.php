<?php

use Illuminate\Database\Seeder;
use Illuminate\Database\Eloquent\Model;
use App\Theme;
use App\Question;
use App\User;

class DatabaseSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Model::unguard();

        $this->call(ThemesSeeder::class);
        $this->call(QuestionsSeeder::class);
        $this->call(UsersSeeder::class);

        Model::reguard();
    }
}

class ThemesSeeder extends Seeder {

    public function run()
    {
        DB::table('themes')->delete();

        $themes = array(
            "Sports et Loisirs",
            "Education",
            "Arts et Culture",
            "Recherche et Innovation",
            "Agriculture",
            "Transports",
            "Santé et Social",
            "Etat et Action Publique",
            "Défense",
            "Justice",
            "Communication et Médias",
            "Energie et Environnement",
            "Finances",
            "Economie",
            "Politique Étrangère",
            "Politique Intérieure",
            "Immigration",
        );

        foreach($themes as $theme)
        {
            Theme::create([
                'name' => $theme
            ]);
        }
    }
}

class QuestionsSeeder extends Seeder {

    public function run()
    {
        DB::table('questions')->delete();

        $theme = Theme::first();

        $question = Question::create([
            'text' => "Oskar Freysinger est bon pour la Suisse",
            'author' => 'fdett',
            'source' => 'me',
        ]);

        $question->themes()->attach($theme->id);
    }
}

class UsersSeeder extends Seeder {

    public function run()
    {
        DB::table('users')->delete();

        User::create([
            'email' => "fabrice.dettwiler@gmail.com",
            'password' => '123456',
        ]);

    }
}
