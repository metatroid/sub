class Upload < ActiveRecord::Base
	attr_accessible :user_id, :photo, :video, :audio, :image, :archive
	belongs_to :user
	has_attached_file :photo, :styles => { :thumb => ["75x75>"], :display => ["250x250>"] }
	has_attached_file :video, :styles => { :flv => {:format => 'flv'}, :mp4 => {:format => 'mp4'} }, :processors => [:videncode],
																				:url => "/system/:attachment/:id/:style/:filename"
	has_attached_file :audio, :styles => {
																					:mp3        => {:format => 'mp3'},
																					:wav        => {:format => 'wav'}
																				},
																				:url => "/system/:attachment/:id/:style/:filename", :processors => [:encode]
	has_attached_file :image, :styles => { :thumb => ["75x75>"] }, :url => "/system/:attachment/:id/:style/:filename"
	has_attached_file :archive
	before_validation :find_mimetype
	validates_attachment_content_type(:photo, :content_type => ['image/png', 'image/gif', 'image/jpeg', 'image/pjpeg'])
	validates_attachment_content_type(:video, :content_type => ['video/quicktime', 'video/mpeg', 'video/mp4', 'video/ogg', 'video/x-msvideo', 'video/x-flv', 'video/x-matroska'])
	validates_attachment_content_type(:audio, :content_type => ['audio/mpeg', 'audio/x-wav', 'audio/ogg','audio/x-ogg', 'audio/x-ogg-vorbis', 'application/ogg', 'audio/x-vorbis', 'audio/vorbis', 'audio/vnd.wave'])
	validates_attachment_content_type(:image, :content_type => ['image/png', 'image/gif', 'image/jpeg', 'image/pjpeg'])
	validates_attachment_content_type(:archive, :content_type => ['application/x-rar-compressed', 'application/x-gzip', 'application/zip', 'application/x-rar'])
	after_create :add_urls
	
	def find_mimetype
		if self.photo.to_file
			photo = self.photo.to_file.path
			file = File.open(photo)
			mime = File.mime_type?(file)
			self.photo.instance_write(:content_type, mime)
		end
		if self.video.to_file
			video = self.video.to_file.path
			vfile = File.open(video)
			vmime = File.mime_type?(vfile)
			self.video.instance_write(:content_type, vmime)
		end
		if self.audio.to_file
			audio = self.audio.to_file.path
			afile = File.open(audio)
			amime = File.mime_type?(afile)
			self.audio.instance_write(:content_type, amime)
		end
		if self.image.to_file
			image = self.image.to_file.path
			ifile = File.open(image)
			imime = File.mime_type?(ifile)
			self.image.instance_write(:content_type, imime)
		end
		if self.archive.to_file
			archive = self.archive.to_file.path
			rfile = File.open(archive)
			rmime = File.mime_type?(rfile)
			self.archive.instance_write(:content_type, rmime)
		end
	end
	
	def add_urls
		if self.audio.to_file
			update_attribute :direct, "http://q.metatroid.com#{self.audio.url}"
			update_attribute :display, "http://q.metatroid.com/file/#{self.id}/#{self.audio_file_name.gsub(self.audio_file_name.split('.').last, '').gsub('.', '')}?type=#{self.audio_file_name.split('.').last}"
		end
		if self.video.to_file
			update_attribute :direct, "http://q.metatroid.com#{self.video.url}"
			update_attribute :display, "http://q.metatroid.com/file/#{self.id}/#{self.video_file_name.gsub(self.video_file_name.split('.').last, '').gsub('.', '')}?type=#{self.video_file_name.split('.').last}"
		end
		if self.image.to_file
			update_attribute :direct, "http://q.metatroid.com#{self.image.url}"
		end
	end
end
