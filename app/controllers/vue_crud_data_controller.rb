class VueCrudDataController < ApplicationController
  before_action :set_datum, only: [:update, :destroy]

  def index
    @data = VueCrudDatum.all.order(updated_at: 'DESC')

    respond_to do |format|
      # html用
      format.html
      # json用
      format.json { render json: @data }
    end
  end

  # 全て初期化
  def new
    ActiveRecord::Base.transaction do
      # 高速削除
      ActiveRecord::Base.connection.execute("TRUNCATE TABLE vue_crud_data;")
      # 高速挿入
      ActiveRecord::Base.connection.execute("INSERT INTO vue_crud_data SELECT * FROM vue_crud_data_bks;")
    end

    redirect_to root_url
  end

  def create
    @datum = VueCrudDatum.new(datum_params)

    respond_to do |format|
      if @datum.save
        format.json { render json: { registration: "Ajaxによるデータの登録が成功しました。",
           id: @datum.id, name: @datum.name, comment: @datum.comment, updated_at: @datum.updated_at } }
      else
        format.json { render json: { registratio: 'Ajaxによるデータの登録が失敗しました。',
          id: 'error' } }
      end
    end
  end

  def update
    respond_to do |format|
      if @datum.update(datum_params)
        format.json { render json: { registration: "Ajaxによるデータの更新が成功しました。" } }
      else
        format.json { render json: { registration: "Ajaxによるデータの更新が失敗しました。" } }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @datum.destroy
        format.json { render json: { registration: 'Ajaxによるデータの削除が成功しました。' } }
      else
        format.json { render json: { registration: 'Ajaxによるデータの削除が失敗しました。' } }
      end
    end
  end

  private

  def set_datum
    @datum = VueCrudDatum.find(params[:id])
  end

  def datum_params
    params.require(:datum).permit(:name, :comment)
  end
end
