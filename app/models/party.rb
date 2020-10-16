class Party < ApplicationRecord
  belongs_to :movie
  has_many :party_users, dependent: :destroy
  has_many :users, through: :party_users

  validates :party_date, presence: true
  validates :start_time, presence: true

  def invite(user_ids)
    user_ids.each do |user_id|
      users << User.find(user_id) unless user_id.empty?
    end
  end

  def invitees
    # COMMENT: Hmm, I feel like this could be done with pure active record
    user_relation = users.joins('JOIN party_users AS p_u ON p_u.user_id = users.id').where("party_users.party_id = #{id} AND party_users.attendee_type = 1").distinct

    user_relation.map do |relation|
      relation
    end.sort
  end

  def any_guests?
    !invitees.empty?
  end
end
