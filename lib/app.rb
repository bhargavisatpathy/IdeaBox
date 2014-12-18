require 'idea_box'

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'

  register Sinatra::Partial
  set :partial_template_engine, :erb
  
  not_found do
    erb :error
  end

  get '/' do
    search_phrase = params[:search_phrase]
    ideas = search_phrase ? IdeaStore.search(search_phrase) : IdeaStore.all
    erb :index, locals: {ideas: ideas.sort, idea: Idea.new(params), search_phrase: search_phrase}
  end

  post '/' do
    #params.inspect
    IdeaStore.create(params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

end
