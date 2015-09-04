<?php

namespace App\Http\Controllers;

use App\Theme;
use App\Http\Controllers\Controller;

class ThemeController extends Controller
{
    /**
     * Show the profile for the given user.
     *
     * @param  int  $id
     * @return Response
     */
    public function get()
    {
        $themes = Theme::all();
        return response()->json(['result'=>$themes], 200);;
    }
}