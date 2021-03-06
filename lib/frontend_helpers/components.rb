# frozen_string_literal: true

module FrontendHelpers
  module Components
    include Utils
    include IconComponents

    def icon_tag(name, options = {})
      options[:class] = class_names(['icon', options[:class]])

      tag.span(options) do
        icon_svgs(name)
      end
    end

    def dropdown(html_options = {}, &block)
      html_options.with_defaults!(class: '', data: { controller: 'dropdown' })
      html_options[:class] += ' dropdown is-right'
      button_class = class_names(['button', html_options.delete(:button_class)])
      button_content = html_options.delete(:button_content) || icon_svgs('ellipsis-h')

      content_tag(:div, html_options) do
        trigger_tag = content_tag(:div, class: 'dropdown-trigger') do
          content_tag(:button, title: 'dropdown-button', class: button_class,
                               data: { action: 'dropdown#toggleMenu' }) do
            button_content
          end
        end

        dropdown_tag = content_tag(:div, class: 'dropdown-menu', role: 'menu') do
          content_tag(:div, class: 'dropdown-content') do
            block.call
          end
        end

        trigger_tag + dropdown_tag
      end
    end

    alias ellipsis_dropdown dropdown

    def boolean_icon(value)
      value ? icon_tag('check-circle') : icon_tag('times-circle')
    end

    def active_link(name, path, html_options = nil, &block)
      if block_given?
        html_options = path
        path = name
      end

      html_options ||= {}
      is_active = active_path?(path, html_options[:match])

      html_options[:class] = class_names(html_options[:class], 'is-active': is_active)

      if block_given?
        link_to path, html_options do
          block.call
        end
      else
        link_to name, path, html_options
      end
    end

    def active_li_link(name, path, html_options = {})
      is_active = active_path?(path, html_options[:match])

      tag.li class: class_names('is-active': is_active) do
        link_to name, path
      end
    end

    def link_with_icon(name, icon_name, path, options = {})
      icon = icon_tag(icon_name, class: options.delete(:icon_class))

      link_to path, options do
        icon + tag.span(name)
      end
    end

    def generate_link_to(name, options, html_options, &block)
      options ||= {}

      html_options = convert_options_to_data_attributes(options, html_options)

      url = url_for(options)
      html_options['href'] ||= url
      html_options['data-redirect-to'] = request.path

      content_tag('a', name || url, html_options, &block)
    end

    # Convinience method to launch a link within a modal.
    # Appends the data-action="remote-modal#open" to trigger the RemoteModalController
    #
    def link_to_modal(name, options = nil, html_options = nil, &block)
      if block_given?
        html_options = options
        options = name
        name = block
      end

      html_options ||= {}
      html_options['data-action'] = 'remote-modal#open'
      generate_link_to(name, options, html_options, &block)
    end

    # Convinience method to launch a link within a drawer.
    # Appends the data-action="remote-drawer#open" to trigger the RemoteDrawerController
    #
    def link_to_drawer(name, options = nil, html_options = nil, &block)
      if block_given?
        html_options = options
        options = name
        name = block
      end

      html_options ||= {}
      html_options['data-action'] = 'remote-drawer#open'
      generate_link_to(name, options, html_options, &block)
    end

    # Adds the submit-button stimulus controller so that the Submit button
    # displays a spinner when clicked.
    #
    def form_with(**options, &block)
      options[:data] ||= {}
      options[:data][:controller] = "#{options.dig(:data, :controller)} submit-button".strip

      super(**options, &block)
    end

    def hovercard(&block)
      html_content = capture(&block)
      card_content = tag.div class: 'card-content' do
        tag.div html_content, class: 'content'
      end
      tag.div class: 'hovercard card' do
        safe_join([card_content, card_notch])
      end
    end

    def card_notch
      tag.svg width: 20, height: 8, viewBox: '0 0 20 8', fill: 'none' do
        tag.path 'fill-rule': 'evenodd',
                 'clip-rule': 'evenodd',
                 d: 'M10 8C13 8 15.9999 0 20 0H0C3.9749 0 7 8 10 8Z',
                 fill: 'white'
      end
    end
  end
end
