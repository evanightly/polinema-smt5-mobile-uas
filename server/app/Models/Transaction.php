<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'payment_method', // ['Cash', 'Credit Card', 'Debit Card']
        'payment_proof',
        'payment_date',
        'total',
        'status', // ['On Going', 'Pending', 'Rejected', 'Verified', 'Finished']
        'verified_by', // Admin
        'verified_at',
        'delivery_address',
    ];

    protected $casts = [
        'payment_date' => 'datetime',
        'verified_at' => 'datetime',
    ];

    // User has many transaction of car
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function verifiedBy()
    {
        return $this->belongsTo(Admin::class, 'verified_by');
    }

    public function detailTransactions()
    {
        return $this->hasMany(DetailTransaction::class, 'transaction_id', 'id');
    }

    public function getPaymentProofUrlAttribute()
    {
        // check if image starts with http
        if (strpos($this->payment_proof, 'http') === 0) {
            return $this->payment_proof;
        }
        return asset('storage/images/payment_proof/' . $this->payment_proof);
    }

    public function getFormattedCreatedAtAttribute()
    {
        return $this->created_at->format('d F Y');
    }

    public function getFormattedVerifiedAtAttribute()
    {
        // return formatted verified at date, but if null return empty string
        return $this->verified_at ? $this->verified_at->format('d F Y') : '';
        // return $this->verified_at->format('d F Y');
    }

    public function getFormattedTotalAttribute()
    {
        return number_format($this->total, 0, ',', '.');
    }

    // public function getPaymentProofAttribute($value)
    // {
    //     return asset('storage/transaction_proof' . $value);
    // }
}
