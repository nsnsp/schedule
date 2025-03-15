# -*- coding: utf-8 -*-
module Commitments
  class Patrol < Commitment
    def self.bootstrap_class_suffix() 'danger' end
    def self.display_color() '#D9534F' end
  end

  class PatrolPM < Commitment
    def self.display_color() '#D9534F' end
    def self.display_text() 'Patrol (½)' end
    def self.bootstrap_class_suffix() 'danger' end
    def self.day_multiplier() 0.5 end
  end

  class PatrolAuxiliary < Commitment
    def self.display_color() '#D9534F' end
    def self.display_text() 'Patrol (MMHQ)' end
    def self.bootstrap_class_suffix() 'danger' end
  end

  class Instructor < Commitment
    def self.display_color() '#5CB85C' end
    def self.display_text() 'Instruct (OEC)' end
    def self.bootstrap_class_suffix() 'success' end
  end

  class InstructorTransport < Commitment
    def self.display_color() '#5CB85C' end
    def self.display_text() 'Instruct (OET)' end
    def self.bootstrap_class_suffix() 'success' end
  end

  class Candidate < Commitment
    def self.display_color() '#F0AD4E' end
    def self.display_verb() 'Attend training' end
    def self.bootstrap_class_suffix() 'warning' end
  end
  
  class CandidateAuxilary < Commitment
    def self.display_color() '#F0AD4E' end
    def self.display_verb() 'Attend training (MMHQ)' end
    def self.bootstrap_class_suffix() 'warning' end
  end

  class Other < Commitment
    def self.display_color() '#5BC0DE' end
    def self.display_text() 'Special Event' end
    def self.display_verb() 'Attent special event' end
    def self.bootstrap_class_suffix() 'info' end
  end

  DISPLAY_ORDER = [Other, Patrol, PatrolPM, PatrolAuxiliary,
                   Instructor, InstructorTransport, Candidate, CandidateAuxilary]
end
