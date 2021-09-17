<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Jobs\TestJob;

class RetroReminder extends Controller
{
    public function reminder()
    {
        TestJob::dispatch();
    }
}
