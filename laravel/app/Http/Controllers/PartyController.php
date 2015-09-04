<?php

namespace App\Http\Controllers;

use App\Party;
use App\Http\Controllers\Controller;

class PartyController extends Controller
{
    /**
     * Show the profile for the given user.
     *
     * @param  int  $id
     * @return Response
     */
    public function get()
    {
        $parties = Party::all();
        return response()->json(['result'=>$parties], 200);;
    }
}