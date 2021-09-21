<?php

namespace App\Http\Controllers;

use App\Jobs\CreateDummyUsers;
use App\Models\User;
use Illuminate\Http\Request;

class QueueRunController extends Controller
{
    public function runQueue()
    {
        CreateDummyUsers::dispatch();
        return "Users created";
    }
}
