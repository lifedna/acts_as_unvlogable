# ----------------------------------------------
#  Class for Myspace (vids.myspace.com)
#  http://vids.myspace.com/index.cfm?fuseaction=vids.individual&VideoID=27111431
# ----------------------------------------------


class VgMyspace
  
  def initialize(url=nil, options={})
    @url = url
    @video_id = parse_url(url)
    res = Net::HTTP.get(URI.parse("http://mediaservices.myspace.com/services/rss.ashx?type=video&videoID=#{@video_id}"))
    @feed = REXML::Document.new(res)
  end
  
  def title
    REXML::XPath.first(@feed, "//item/title")[0].to_s
  end
  
  def thumbnail
    REXML::XPath.first(@feed, "//media:thumbnail").attributes['url']
  end
  
  def embed_url
    "http://lads.myspace.com/videos/vplayer.swf?m=#{REXML::XPath.first( @feed, "//myspace:itemID" )[0]}&v=2&type=video"
  end

  def embed_html(width=425, height=344, options={})
    "<embed src='#{embed_url}' type='application/x-shockwave-flash' width='#{width}' height='#{height}'></embed>"
  end
  
  def flv
    REXML::XPath.first(@feed, "//media:content").attributes['url']
  end
  
  private
  
  def parse_url(url)
    uri = URI.parse(url)
    args = uri.query
    video_id = ''
    if args and args.split('&').size >= 1
      args.split('&').each do |arg|
        k,v = arg.split('=')
        video_id = v and break if k.downcase == 'videoid'
      end
      raise unless video_id
    else
      raise
    end
    video_id
  end
  
end