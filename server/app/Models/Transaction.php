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

    public function transactionDetails()
    {
        return $this->hasMany(TransactionDetail::class);
    }

    public function getPaymentProofAttribute($value)
    {
        return asset('storage/transaction_proof' . $value);
    }
}
