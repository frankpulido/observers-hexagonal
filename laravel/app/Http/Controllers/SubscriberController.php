<?php
declare(strict_types=1);
namespace App\Http\Controllers;

use App\Models\Subscriber;
use Illuminate\Http\Request;

class SubscriberController extends Controller
{
    public function index()
    {
        $subscribers = Subscriber::all();
        return response()->json([
            'subscribers' => $subscribers], 200);
    }
}
