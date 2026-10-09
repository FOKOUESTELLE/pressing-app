<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\User;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Comptes de test : uniquement en environnement local
        if (! app()->environment('local')) {
            $this->command->warn('Seeder de test ignoré hors environnement local.');
            return;
        }

        $accounts = [
            ['Admin Test',       'admin@pressing.test',       'ADMIN'],
            ['Responsable Test', 'responsable@pressing.test', 'RESPONSABLE'],
            ['Coursier Test',    'coursier@pressing.test',    'COURSIER'],
            ['Client Test',      'client@pressing.test',      'CLIENT'],
        ];

        foreach ($accounts as [$name, $email, $role]) {
            User::updateOrCreate(
                ['email' => $email],
                [
                    'name'     => $name,
                    'password' => 'password123', // haché automatiquement (cast 'hashed')
                    'phone'    => '690000000',
                    'address'  => 'Adresse de test',
                    'role'     => $role,
                ]
            );
        }

        // Catégories d'exemple (prix en FCFA, à adapter)
        $categories = [
            ['Costume',   2500],
            ['Chemise',    500],
            ['Pantalon',   700],
            ['Robe',      1500],
        ];

        foreach ($categories as [$name, $price]) {
            Category::firstOrCreate(['name' => $name], ['price' => $price]);
        }
    }
}