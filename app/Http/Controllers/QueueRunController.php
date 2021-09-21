<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;

class QueueRunController extends Controller
{
    public function runQueue()
    {
        User::factory()->count(10)->create();
    }
}
