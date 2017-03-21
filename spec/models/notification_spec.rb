require 'rails_helper'
include Rails.application.routes.url_helpers

describe Notification do

  describe "#unread (scope)" do
    it "returns only unread notifications" do
      2.times { create :notification }
      expect(Notification.unread.size).to be 2
    end
  end

  describe "#recent (scope)" do
    it "returns notifications sorted by id descendant" do
      old_notification = create :notification
      new_notification = create :notification

      sorted_notifications = Notification.recent
      expect(sorted_notifications.size).to be 2
      expect(sorted_notifications.first).to eq new_notification
      expect(sorted_notifications.last).to eq old_notification
    end
  end

  describe "#for_render (scope)" do
    it "returns notifications including notifiable and user" do
      expect(Notification).to receive(:includes).with(:notifiable).exactly(:once)
      Notification.for_render
    end
  end

  describe "#timestamp" do
    it "returns the timestamp of the trackable object" do
      comment = create :comment
      notification = create :notification, notifiable: comment

      expect(notification.timestamp).to eq comment.created_at
    end
  end

  describe "#mark_as_read" do
    it "destroys notification" do
      notification = create :notification
      expect(Notification.unread.size).to eq 1

      notification.mark_as_read
      expect(Notification.unread.size).to eq 0
    end
  end

  describe "#notifiable_title" do

    it "returns the debate's title when notifiable is a debate" do
      debate = create(:debate)
      notification = create :notification, notifiable: debate

      expect(notification.notifiable_title).to eq debate.title
    end

    it "returns the proposal's title when notifiable is a proposal" do
      proposal = create(:proposal)
      notification = create :notification, notifiable: proposal

      expect(notification.notifiable_title).to eq proposal.title
    end

    it "returns the investment's title when notifiable is an investment" do
      investment = create(:budget_investment)
      notification = create :notification, notifiable: investment

      expect(notification.notifiable_title).to eq investment.title
    end

  end

  describe "#notification_action" do

    context "when action was comment on a debate" do
      it "returns correct text when someone comments on your debate" do
        debate = create(:debate)
        notification = create :notification, notifiable: debate

        expect(notification.notifiable_action).to eq "comments_on"
      end
    end

    context "when action was comment on a debate" do
      it "returns correct text when someone replies to your comment" do
        debate = create(:debate)
        debate_comment = create :comment, commentable: debate
        notification = create :notification, notifiable: debate_comment

        expect(notification.notifiable_action).to eq "replies_to"
      end
    end

    context "when action was proposal notification" do
      it "returns correct text when the author created a proposal notification" do
        proposal_notification = create(:proposal_notification)
        notification = create :notification, notifiable: proposal_notification

        expect(notification.notifiable_action).to eq "proposal_notification"
      end
    end

  end

  describe "#notifiable_url" do

    it "returns the debates's url when notifiable is a debate" do
      debate = create(:debate)
      notification = create(:notification, notifiable: debate)

      expect(notification.notifiable_url).to eq debate_url(debate)
    end

    it "returns the proposal's url when notifiable is a proposal" do
      proposal = create(:proposal)
      notification = create(:notification, notifiable: proposal)

      expect(notification.notifiable_url).to eq proposal_url(proposal)
    end

    it "returns the proposal's url when notifiable is a proposal notification" do
      proposal = create(:proposal)
      proposal_notification = create(:proposal_notification, proposal: proposal)
      notification = create(:notification, notifiable: proposal_notification)

      expect(notification.notifiable_url).to eq proposal_path(proposal)
    end

    it "returns the investment's url when notifiable is an investment" do
      investment = create(:budget_investment)
      notification = create(:notification, notifiable: investment)

      expect(notification.notifiable_url).to eq budget_investment_path(investment.budget, investment)
    end

  end

end
