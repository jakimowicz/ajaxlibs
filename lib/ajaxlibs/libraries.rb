module Ajaxlibs
  Libraries = {
    :jquery => {
      '1.2.3' => {},
      '1.2.6' => {},
      '1.3.0' => {},
      '1.3.1' => {},
      '1.3.2' => {},
      '1.4.0' => {},
      '1.4.1' => {},
      '1.4.2' => {}
    },
    :jqueryui => {
      '1.5.2' => {:uncompressed => 'jquery-ui', :requires => :jquery},
      '1.5.3' => {:uncompressed => 'jquery-ui', :requires => :jquery},
      '1.6'   => {:uncompressed => 'jquery-ui', :requires => :jquery},
      '1.7.0' => {:uncompressed => 'jquery-ui', :requires => :jquery},
      '1.7.1' => {:uncompressed => 'jquery-ui', :requires => :jquery},
      '1.7.2' => {:uncompressed => 'jquery-ui', :requires => :jquery}
    },
    :prototype => {
      '1.6.0.2' => {},
      '1.6.0.3' => {},
      '1.6.1.0' => {}
    },
    :scriptaculous => {
      '1.8.1' => {:requires => :prototype},
      '1.8.2' => {:requires => :prototype},
      '1.8.3' => {:requires => :prototype}
    }
  }
end