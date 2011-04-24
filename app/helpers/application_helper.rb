module ApplicationHelper

	def title
		base_title = "The Internet"
		if @title.nil?
			base_title
		else 
			"#{base_title} :: #{@title}"
		end
	end
	def shorturl(url)
		bitly = Bitly.new('metatroid', 'R_989b18cb9ba7418ce979bb0aa5b31a71')
		bitly.shorten(url)
	end
end
