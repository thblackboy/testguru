class GistQuestionService
  def initialize(question, client: default_client)
    @question = question
    @test = @question.test
    @client = client
    @gist_struct = Struct.new(:gist_url) do
      def success?
        gist_url != nil
      end
    end
  end

  def call
    @gist_struct.new(@client.create_gist(gist_params).html_url)
  end

  private

  def gist_params
    {
      description: I18n.t('.gist_description', test_title: @test.title),
      files: {
        'test-guru-question.txt' => {
          content: gist_content
        }
      }
    }
  end

  def default_client
    Octokit::Client.new(access_token: Rails.application.credentials.git_hub_api_key)
  end

  def gist_content
    [@question.body, *@question.answers.pluck(:body)].join("\n")
  end
end
