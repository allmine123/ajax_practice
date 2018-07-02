class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def map
  end
  def map_data
    max = JSON.parse(params[:max]) #JSONstring => hash
    min = JSON.parse(params[:min]) #SONstring => hash
    indices = JSON.parse(params[:indices]) #네이버 앱에 이미 로딩되어 있는 학교들의 id
    school = School.where("(lat BETWEEN ? AND ?) and (lng BETWEEN ? and ?)",min["_lat"],max["_lat"],min["_lng"],max["_lng"])
    school_id = school.map{|x| x.id}
    school_id -= indices #기존에 네이버 맵에 로딩되어 있지 않은 학교들의 id만 저장되어 있음
    if school_id.length == 0
      school = []
    else
      school = school.select{|x| school_id.include? x.id} #school_id에 존재하는 학교들만 school에 저장
    end

    #@school = School.all.limit(100)
    respond_to do |format|
      format.json { render json: [school, school_id] } #자동으로 json 형식으로 바꿔줌.
    end
  end
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    @post = Post.new
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to '/posts', notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
        format.js {}
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :content)
    end
end
