class VideosController < ApplicationController
  before_action :set_video, only: %i[update destroy]

  # PATCH/PUT /videos/1 or /videos/1.json
  def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to playlist_url(@video.playlist), notice: "Video was successfully updated." }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { redirect_to playlist_url(@video.playlist), notice: "Video could not be updated." }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1 or /videos/1.json
  def destroy
    @video.destroy!

    respond_to do |format|
      format.html { redirect_to playlist_url(@video.playlist), notice: "Video was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_video
    @video = Video.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def video_params
    params.require(:video).permit(:playlist_id, :videoid, :title, :downloaded_at, :watched_at, :deleted_at)
  end
end
