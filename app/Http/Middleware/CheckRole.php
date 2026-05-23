<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class CheckRole
{
    public function handle(Request $request, Closure $next, ...$roles)
    {
        $user = $request->session()->get('user');

        if (!$user) {
            return redirect()->route('index')->with('error', 'Please login to access this page.');
        }

        if (!in_array($user->role, $roles)) {
            return redirect()->route('index')->with('error', 'You do not have permission to access this area.');
        }

        return $next($request);
    }
}
