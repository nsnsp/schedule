module Commitments
  class Patrol < Commitment
    def self.bootstrap_label_class
      'label-danger'
    end
  end

  class PatrolAM < Commitment
    def self.display
      'Patrol (AM)'
    end

    def self.bootstrap_label_class
      'label-danger'
    end
  end

  class PatrolPM < Commitment
    def self.display
      'Patrol (PM)'
    end

    def self.bootstrap_label_class
      'label-danger'
    end
  end

  class Instructor < Commitment
    def self.bootstrap_label_class
      'label-success'
    end
  end

  class Candidate < Commitment
    def self.bootstrap_label_class
      'label-warning'
    end
  end

  class Other < Commitment
    def self.display
      'Special Event'
    end

    def self.bootstrap_label_class
      'label-info'
    end
  end

  DISPLAY_ORDER = [Other, Patrol, PatrolAM, PatrolPM, Instructor, Candidate]
end
