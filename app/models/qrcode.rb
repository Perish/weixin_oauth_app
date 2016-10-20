require 'zip'
class Qrcode < ApplicationRecord
	default_scope -> {order(created_at: :desc)}

	# 二维码
	mount_uploader :image, ImageUploader

	def qrcode_default_url
		"https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=#{ticket}"
	end

	def self.deal_with(ss)
		# 已经存在
		exist_arr = []
		# 创建失败
		fail_arr = []
		# 创建成功
		success_arr = []

		# 循环创建
		ss.each do |x|
			if find_by(scene: x.strip).present?
				exist_arr << x.strip
			else
				result = $client.create_qr_limit_str_scene({scene_str: x.strip})
				if result.en_msg == "ok" 
					create({ticket: result.result["ticket"], url: result.result["url"], scene: x.strip, weixin_id: 0})
					success_arr << x.strip
				else
					arr << x.strip
				end
			end
		end
		notice = ""
		notice += "总共有#{ss.length}个关键字"
		notice += "; 创建成功: #{success_arr.length}个 (#{success_arr.join(",")})" if success_arr.length > 0
		notice += "; 创建失败: #{fail_arr.length}个 (#{fail_arr.join(",")})" if fail_arr.length > 0
		notice += "; 已经存在: #{exist_arr.length}个 (#{exist_arr.join(",")})" if exist_arr.length > 0
		return notice
	end

	# 下载二维码
	after_create :load_image
	def load_image
		logger.info "load_image-----"
		response = RestClient::Resource.new(qrcode_default_url).get
		logger.info "response.code=======#{response.code}"
		logger.info "response.code=======#{qrcode_default_url}"
		if response.code == 200
			f = File.new("#{scene}.png", 'wb')
			f << response.body
			self.image = f
			self.save
			f.close
			`rm #{Rails.root}/#{scene}.png`
		end
	end

	# zip 二维码
	def self.zip_qrcode(ids)
			qrcodes = Qrcode.where(id: ids)
			zipfile_name = "#{Rails.root}/archive-#{Time.now.to_i}.zip"
			::Zip::File.open(zipfile_name, ::Zip::File::CREATE) do |zipfile|
			  qrcodes.each do |qrcode|
			  	file_path = "#{Rails.root}/public#{qrcode.image_url}"
			  	puts file_path
			    # Two arguments:
			    # - The name of the file as it will appear in the archive
			    # - The original file, including the path to find it
			    zipfile.add("#{qrcode.scene}.png", file_path)
			  end
			  zipfile.get_output_stream("read.txt") { |os| os.write "二维码" }
			end
			return zipfile_name
	end



   #  arr = []
   #  arr_exist = []
   #  ss.each do |x|
   #    if !Qrcode.where(scene: x.strip).first.present?
   #    	result = $client.create_qr_limit_str_scene({scene_str: x.strip})
   #      if result.en_msg == "ok"
   #    	   Qrcode.create({ticket: result.result["ticket"], url: result.result["url"], scene: x.strip, weixin_id: 0})
   #      else
   #        arr << x.strip
   #      end
   #    else
   #      arr_exist << x.strip
   #    end
   #  end
   #  if arr.length > 0
   #    notice = "这些  #{arr.join(",")}  没有创建成功"
   #  end
   #  if arr_exist.length > 0
   #    notice = " #{arr_exist.join(",") } 已经存在！"
   #  end
   #  notice = "创建成功" if notice.blank?
  	# redirect_to qrcodes_url, flash: {notice: notice}
end
