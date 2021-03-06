module RidesHelper
  def dollars(amount)
    if amount.nil?
      ""
    else
      number_to_currency(amount, unit: '$')
    end
  end

  def seats_remaining(ride)
    total = ride.seats
    taken = ride.passengers.count
    if total.nil?
      "Unlimited (#{taken} taken)"
    else
      remaining = total - taken
      "#{remaining} of #{total}"
    end
  end
end
