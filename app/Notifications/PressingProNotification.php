<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class PressingProNotification extends Notification
{
    use Queueable;

    protected $titre;
    protected $message;
    protected $type;
    protected $donnees;

    /**
     * Create a new notification instance.
     */
    public function __construct($titre, $message, $type, $donnees = [])
    {
        $this->titre = $titre;
        $this->message = $message;
        $this->type = $type;
        $this->donnees = $donnees;
    }


    /**
     * Get the notification's delivery channels.
     *
     * @return array<int, string>
     */

    // Enregistrer la notification dans la base de données
    public function via(object $notifiable): array
    {
        return ['database'];
    }

    /**
     * Get the array representation of the notification.
     *
     * @return array<string, mixed>
     */
    
    public function toMail(object $notifiable): MailMessage
    {
        return (new MailMessage)
            ->line('The introduction to the notification.')
            ->action('Notification Action', url('/'))
            ->line('Thank you for using our application!');
    }

    /**
     * Get the array representation of the notification.
     *
     * @return array<string, mixed>
     */
    public function toArray(object $notifiable): array
    {
        return [
                'titre' => $this->titre,
                'message' => $this->message,
                'type' => $this->type,
                'donnees' => $this->donnees,
        ];
    }
}
