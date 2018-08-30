class GraphvizController < ApplicationController
  unloadable

  def convert
    frmt = GraphvizHelper.check_format(params[:content_type])
    filename = params[:filename]
    send_file(GraphvizHelper.graphviz_file(filename, frmt[:ext]), type: frmt[:content_type], disposition: frmt[:inline])
  end
end
