module Commitments
  class Patrol < Commitment
    def self.bootstrap_label_class() 'label-danger' end
    def self.display_color() '#D9534F' end
  end

  class PatrolAM < Commitment
    def self.bootstrap_label_class() 'label-danger' end
    def self.display_color() '#D9534F' end
    def self.display_text() 'Patrol (AM)' end
  end

  class PatrolPM < Commitment
    def self.display_color() '#D9534F' end
    def self.display_text() 'Patrol (PM)' end
    def self.bootstrap_label_class() 'label-danger' end
  end

  class Instructor < Commitment
    def self.display_color() '#5CB85C' end
    def self.bootstrap_label_class() 'label-success' end
  end

  class Candidate < Commitment
    def self.display_color() '#F0AD4E' end
    def self.bootstrap_label_class() 'label-warning' end
  end

  class Other < Commitment
    def self.display_color() '#5BC0DE' end
    def self.display_text() 'Special Event' end
    def self.bootstrap_label_class() 'label-info' end
  end

  DISPLAY_ORDER = [Other, Patrol, PatrolAM, PatrolPM, Instructor, Candidate]
end
