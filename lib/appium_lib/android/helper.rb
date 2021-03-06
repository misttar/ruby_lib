# encoding: utf-8
module Appium::Android
  # Returns an array of android classes that match the tag name
  # @param tag_name [String] the tag name to convert to an android class
  # @return [String]
  def tag_name_to_android tag_name
    tag_name = tag_name.to_s.downcase.strip

    # @private
    def prefix *tags
      tags.map!{ |tag| "android.widget.#{tag}" }
    end
    # note that 'secure' is not an allowed tag name on android
    # because android can't tell what a secure textfield is
    # they're all edittexts.

    # must match names in AndroidElementClassMap (Appium's Java server)
    case tag_name
      when 'abslist'
        prefix 'AbsListView'
      when 'absseek'
        prefix 'AbsSeekBar'
      when 'absspinner'
        prefix 'AbsSpinner'
      when 'absolute'
        prefix 'AbsoluteLayout'
      when 'adapterview'
        prefix 'AdapterView'
      when 'adapterviewanimator'
        prefix 'AdapterViewAnimator'
      when 'adapterviewflipper'
        prefix 'AdapterViewFlipper'
      when 'analogclock'
        prefix 'AnalogClock'
      when 'appwidgethost'
        prefix 'AppWidgetHostView'
      when 'autocomplete'
        prefix 'AutoCompleteTextView'
      when 'button'
        prefix 'Button', 'ImageButton'
      when 'breadcrumbs'
        prefix 'FragmentBreadCrumbs'
      when 'calendar'
        prefix 'CalendarView'
      when 'checkbox'
        prefix 'CheckBox'
      when 'checked'
        prefix 'CheckedTextView'
      when 'chronometer'
        prefix 'Chronometer'
      when 'compound'
        prefix 'CompoundButton'
      when 'datepicker'
        prefix 'DatePicker'
      when 'dialerfilter'
        prefix 'DialerFilter'
      when 'digitalclock'
        prefix 'DigitalClock'
      when 'drawer'
        prefix 'SlidingDrawer'
      when 'expandable'
        prefix 'ExpandableListView'
      when 'extract'
        prefix 'ExtractEditText'
      when 'fragmenttabhost'
        prefix 'FragmentTabHost'
      when 'frame'
        prefix 'FrameLayout'
      when 'gallery'
        prefix 'Gallery'
      when 'gesture'
        prefix 'GestureOverlayView'
      when 'glsurface'
        prefix 'GLSurfaceView'
      when 'grid'
        prefix 'GridView'
      when 'gridlayout'
        prefix 'GridLayout'
      when 'horizontal'
        prefix 'HorizontalScrollView'
      when 'image'
        prefix 'ImageView'
      when 'imagebutton'
        prefix 'ImageButton'
      when 'imageswitcher'
        prefix 'ImageSwitcher'
      when 'keyboard'
        prefix 'KeyboardView'
      when 'linear'
        prefix 'LinearLayout'
      when 'list'
        prefix 'ListView'
      when 'media'
        prefix 'MediaController'
      when 'mediaroutebutton'
        prefix 'MediaRouteButton'
      when 'multiautocomplete'
        prefix 'MultiAutoCompleteTextView'
      when 'numberpicker'
        prefix 'NumberPicker'
      when 'pagetabstrip'
        prefix 'PageTabStrip'
      when 'pagetitlestrip'
        prefix 'PageTitleStrip'
      when 'progress'
        prefix 'ProgressBar'
      when 'quickcontactbadge'
        prefix 'QuickContactBadge'
      when 'radio'
        prefix 'RadioButton'
      when 'radiogroup'
        prefix 'RadioGroup'
      when 'rating'
        prefix 'RatingBar'
      when 'relative'
        prefix 'RelativeLayout'
      when 'row'
        prefix 'TableRow'
      when 'rssurface'
        prefix 'RSSurfaceView'
      when 'rstexture'
        prefix 'RSTextureView'
      when 'scroll'
        prefix 'ScrollView'
      when 'search'
        prefix 'SearchView'
      when 'seek'
        prefix 'SeekBar'
      when 'space'
        prefix 'Space'
      when 'spinner'
        prefix 'Spinner'
      when 'stack'
        prefix 'StackView'
      when 'surface'
        prefix 'SurfaceView'
      when 'switch'
        prefix 'Switch'
      when 'tabhost'
        prefix 'TabHost'
      when 'tabwidget'
        prefix 'TabWidget'
      when 'table'
        prefix 'TableLayout'
      when 'text'
        prefix 'TextView'
      when 'textclock'
        prefix 'TextClock'
      when 'textswitcher'
        prefix 'TextSwitcher'
      when 'texture'
        prefix 'TextureView'
      when 'textfield'
        prefix 'EditText'
      when 'timepicker'
        prefix 'TimePicker'
      when 'toggle'
        prefix 'ToggleButton'
      when 'twolinelistitem'
        prefix 'TwoLineListItem'
      when 'view'
        'android.view.View'
      when 'video'
        prefix 'VideoView'
      when 'viewanimator'
        prefix 'ViewAnimator'
      when 'viewflipper'
        prefix 'ViewFlipper'
      when 'viewgroup'
        prefix 'ViewGroup'
      when 'viewpager'
        prefix 'ViewPager'
      when 'viewstub'
        prefix 'ViewStub'
      when 'viewswitcher'
        prefix 'ViewSwitcher'
      when 'web'
        'android.webkit.WebView' # WebView is not a widget
      when 'window'
        prefix 'FrameLayout'
      when 'zoom'
        prefix 'ZoomButton'
      when 'zoomcontrols'
        prefix 'ZoomControls'
      else
        raise "Invalid tag name #{tag_name}"
    end # return result of case
  end
  # Find all elements matching the attribute
  # On android, assume the attr is name (which falls back to text).
  #
  # ```ruby
  #   find_eles_attr :text
  # ```
  #
  # @param tag_name [String] the tag name to search for
  # @return [Element]
  def find_eles_attr tag_name, attribute=nil
=begin
    sel1 = [ [4, 'android.widget.Button'], [100] ]
    sel2 = [ [4, 'android.widget.ImageButton'], [100] ]

    args = [ 'all', sel1, sel2 ]

    mobile :find, args
=end
    array = ['all']

    tag_name_to_android(tag_name).each do |name|
      # sel.className(name).getStringAttribute("name")
      array.push [ [4, name], [100] ]
    end

    mobile :find, array
  end

  # Selendroid only.
  # Returns a string containing interesting elements.
  # @return [String]
  def get_selendroid_inspect
    # @private
    def run node
      r = []

      run_internal = lambda do |node|
        if node.kind_of? Array
          node.each { |node| run_internal.call node }
          return
        end

        keys = node.keys
        return if keys.empty?

        obj = {}
        # name is id
        obj.merge!( { id: node['name'] } ) if keys.include?('name') && !node['name'].empty?
        obj.merge!( { text: node['value'] } ) if keys.include?('value') && !node['value'].empty?
        # label is name
        obj.merge!( { name: node['label'] } ) if keys.include?('label') && !node['label'].empty?
        obj.merge!( { class: node['type'] } ) if keys.include?('type') && !obj.empty?
        obj.merge!( { shown: node['shown'] } ) if keys.include?('shown')

        r.push obj if !obj.empty?
        run_internal.call node['children'] if keys.include?('children')
      end

      run_internal.call node
      r
    end

    json = get_source
    node = json['children']
    results = run node

    out = ''
    results.each { |e|
      no_text = e[:text].nil?
      no_name = e[:name].nil? || e[:name] == 'null'
      next unless e[:shown] # skip invisible
      # Ignore elements with id only.
      next if no_text && no_name

      out += e[:class].split('.').last + "\n"

      # name is id when using selendroid.
      # remove id/ prefix
      e[:id].sub!(/^id\//, '') if e[:id]

      out += "  class: #{e[:class]}\n"
      # id('back_button').click
      out += "  id: #{e[:id]}\n" unless e[:id].nil?
      # find_element(:link_text, 'text')
      out += "  text: #{e[:text]}\n" unless no_text
      # label is name. default is 'null'
      # find_element(:link_text, 'Facebook')
      out += "  name: #{e[:name]}\n" unless no_name
      # out += "  visible: #{e[:shown]}\n" unless e[:shown].nil?
    }
    out
  end

  def get_page_class
    r = []
    run_internal = lambda do |node|
      if node.kind_of? Array
        node.each { |node| run_internal.call node }
        return
      end

      keys = node.keys
      return if keys.empty?
      r.push node['@class'] if keys.include?('@class')

      run_internal.call node['node'] if keys.include?('node')
    end
    json = get_source
    run_internal.call json['hierarchy']

    res = []
    r = r.sort
    r.uniq.each do |ele|
      res.push "#{r.count(ele)}x #{ele}\n"
    end
    count_sort = ->(one,two) { two.match(/(\d+)x/)[1].to_i <=> one.match(/(\d+)x/)[1].to_i }
    res.sort(&count_sort).join ''
  end

  # Count all classes on screen and print to stdout.
  # Useful for appium_console.
  def page_class
    puts get_page_class
    nil
  end

  # Android only.
  # Returns a string containing interesting elements.
  # If an element has no content desc or text, then it's not returned by this method.
  # @return [String]
  def get_android_inspect
    # @private
    def run node
      r = []

      run_internal = lambda do |node|
        if node.kind_of? Array
          node.each { |node| run_internal.call node }
          return
        end

        keys = node.keys
        return if keys.empty?
        if keys == %w(hierarchy)
          run_internal.call node['hierarchy']
          return
        end

        n_content = '@content-desc'
        n_text = '@text'
        n_class = '@class'
        n_resource = '@resource-id'
        n_node = 'node'

        # Store the object if it has a content description, text, or resource id.
        # If it only has a class, then don't save it.
        obj = {}
        obj.merge!( { desc: node[n_content] } ) if keys.include?(n_content) && !node[n_content].empty?
        obj.merge!( { text: node[n_text] } ) if keys.include?(n_text) && !node[n_text].empty?
        obj.merge!( { resource_id: node[n_resource] } ) if keys.include?(n_resource) && !node[n_resource].empty?
        obj.merge!( { class: node[n_class] } ) if keys.include?(n_class) && !obj.empty?

        r.push obj if !obj.empty?
        run_internal.call node[n_node] if keys.include?(n_node)
      end

      run_internal.call node
      r
    end

    lazy_load_strings
    json = get_source
    node = json['hierarchy']
    results = run node

    out = ''
    results.each { |e|
      e_desc = e[:desc]
      e_text = e[:text]
      e_class = e[:class]
      e_resource_id = e[:resource_id]
      out += e_class.split('.').last + "\n"

      out += "  class: #{e_class}\n"
      if e_text == e_desc
        out += "  text, name: #{e_text}\n" unless e_text.nil?
      else
        out += "  text: #{e_text}\n" unless e_text.nil?
        out += "  name: #{e_desc}\n" unless e_desc.nil?
      end

      out += "  resource_id: #{e_resource_id}\n" unless e_resource_id.nil? || e_resource_id.empty?

      # there may be many ids with the same value.
      # output all exact matches.
      id_matches = @strings_xml.select do |key, value|
        value == e_desc || value == e_text
      end

      if id_matches && id_matches.length > 0
        match_str = ''
        # [0] = key, [1] = value
        id_matches.each do |match|
          match_str += ' ' * 6 + "#{match[0]}\n"
        end
        out += "  id: #{match_str.strip}\n"
      end
    }
    out
  end

  # Automatically detects selendroid or android.
  # Returns a string containing interesting elements.
  # @return [String]
  def get_inspect
    @device == 'Selendroid' ? get_selendroid_inspect : get_android_inspect
  end

  # Intended for use with console.
  # Inspects and prints the current page.
  def page
    puts get_inspect
    nil
  end

  # JavaScript code from https://github.com/appium/appium/blob/master/app/android.js
  #
  # ```javascript
  # Math.round(1.0/28.0 * 28) = 1
  # ```
  #
  # We want steps to be exactly 1. If it's zero then a tap is used instead of a swipe.
  def fast_duration
    0.0357 # 1.0/28.0
  end

  # Lists package, activity, and adb shell am start -n value for current app.
  # Works on local host only (not remote).
  def current_app
    line = `adb shell dumpsys window windows`.each_line.grep(/mFocusedApp/).first.strip
    pair = line.split(' ').last.gsub('}','').split '/'
    pkg = pair.first
    act = pair.last
    OpenStruct.new line: line,
                   package: pkg,
                   activity: act,
                   am_start: pkg + '/' + act
  end

  # Find by id. Useful for selendroid
  # @param id [String] the id to search for
  # @return [Element]
  def id id
    lazy_load_strings
    # resource ids must include ':' and they're not contained in strings_xml
    raise "Invalid id `#{id}`" unless @strings_xml[id] || id.include?(':')
    find_element :id, id
  end
end # module Appium::Android