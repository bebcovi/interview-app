module PlaidGateway
  module RecurringTransactions
    extend self

    REPRESENTATIVE_SIZE = 3

    def extract(transactions)
      transaction_groups = transactions.group_by { |t| [t.name, t.amount] }.values
      transaction_groups.each_with_object([]) do |group, recurring_transactions|
        if representative?(group) && regular_date_intervals?(group)
          recurring_transactions << group
        end
      end
    end

    private

    def representative?(transactions)
      transactions.size >= REPRESENTATIVE_SIZE
    end

    def regular_date_intervals?(transactions)
      regular_day_intervals?(transactions) ||
      regular_month_intervals?(transactions) ||
      regular_year_intervals?(transactions)
    end

    def regular_day_intervals?(transactions)
      day_intervals = transactions.each_cons(2).map { |t1, t2| t2.date - t1.date }
      day_intervals.uniq.count == 1
    end

    def regular_month_intervals?(transactions)
      return false if transactions.map { |t| t.date.day }.uniq.count != 1
      dates_in_months = transactions.map { |t| t.date.year * 12 + t.date.month }
      month_intervals = dates_in_months.each_cons(2).map { |m1, m2| m2 - m1 }
      month_intervals.uniq.count == 1
    end

    def regular_year_intervals?(transactions)
      return false if transactions.map { |t| t.date.day }.uniq.count != 1
      return false if transactions.map { |t| t.date.month }.uniq.count != 1
      year_intervals = transactions.each_const(2).map { |t1, t2| t2.year - t1.year }
      year_intervals.uniq.count == 1
    end
  end
end
