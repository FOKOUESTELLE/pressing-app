<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\Schema;
use Illuminate\Auth\Notifications\ResetPassword;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
       Schema::defaultStringLength(191);
       // Personnaliser le lien de réinitialisation du mot de passe
        ResetPassword::createUrlUsing(function ($user, string $token) {

            return rtrim(env('FRONTEND_URL', 'http://localhost:5173'), '/')
                . '/reinitialiser-mot-de-passe?token=' . $token
                . '&email=' . urlencode($user->getEmailForPasswordReset());

        });
    }
}
