require "test_helper"

class TicketResponsesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ticket_response = ticket_responses(:one)
  end

  test "should get index" do
    get ticket_responses_url, as: :json
    assert_response :success
  end

  test "should create ticket_response" do
    assert_difference("TicketResponse.count") do
      post ticket_responses_url, params: { ticket_response: { message: @ticket_response.message, tech_id: @ticket_response.tech_id, ticket_id: @ticket_response.ticket_id } }, as: :json
    end

    assert_response :created
  end

  test "should show ticket_response" do
    get ticket_response_url(@ticket_response), as: :json
    assert_response :success
  end

  test "should update ticket_response" do
    patch ticket_response_url(@ticket_response), params: { ticket_response: { message: @ticket_response.message, tech_id: @ticket_response.tech_id, ticket_id: @ticket_response.ticket_id } }, as: :json
    assert_response :success
  end

  test "should destroy ticket_response" do
    assert_difference("TicketResponse.count", -1) do
      delete ticket_response_url(@ticket_response), as: :json
    end

    assert_response :no_content
  end
end
