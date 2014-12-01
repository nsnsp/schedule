class GenerateUsers < ActiveRecord::Migration
  def up
    users =
   %w(rossdakin@gmail.com|Ross|Dakin
      fong_er@yahoo.com|Michael|Fong
      pineswyne@gmail.com|Darren|Cooke
      lewismikekdds@gmail.com|Michael|Lewis
      sgwoolpert@comcast.net|Steve|Woolpert
      jasmine@jasminewevers.com|Jasmine|Wevers
      m.klink07@gmail.com|Michael|Klink
      karlrgeisler@yahoo.com|Karl|Geisler
      ejkohen@gmail.com|Evan|Kohen
      thing2smile@aol.com|Kolina|Coe
      nick.r.marker@gmail.com|Nicholas|Marker
      brainfxr@yahoo.com|Keith|Tatsukawa
      d_gobbi@surewest.net|Dan|Gobbi
      garylu@nsnsp.org|Gary|Lu
      Micbay_2001@yahoo.com|Tim|Murphy
      calplates@yahoo.com|Greg|Campbell
      smccormick@greatisland.net|Steve|McCormick
      nlgifford@yahoo.com|Norman|Gifford
      nag@cpdb.com|Nate|Garhart
      robert.e.maxim@gmail.com|Robert|Maxim
      skihaus@mac.com|Michael|Krueger
      varthur@vailresorts.com|Vince|Arthur
      s_throne@hotmail.com|Steve|Throne
      wpcassity@gmail.com|Bill|Cassity
      Jonathancahill82@gmail.com|Jonathan|Cahill
      kqbrown@spt.com|Kathleen|Brown
      tori_simcoe@yahoo.com|Tori|Simcoe
      stameywhite@gmail.com|Rebecca|Stamey-White
      DRozzi@risk-strategies.com|David|Rozzi
      snozone.onaga@sbcglobal.net|Jason|Onaga
      caseyb313@gmail.com|Casey|Bouwhuis
      golf_ski_nsp@yahoo.com|Loretta|Barranger
      lcrcahill@aol.com|Curtis|Cahill
      k3urout@att.net|Jeff|Landucci
      danielcoll@sbcglobal.net|Daniel|Coll
      downs18911@aol.com|Bruce|Downs
      suprruby@sbcglobal.net|Dan|Abbott
      allenwiggins@gmail.com|Allen|Wiggins
      drcassity@sbcglobal.net|Annette|Cassity
      jess.sanford@arsenalinfosec.com|Jess|Sanford
      karen@ktmgt.com|Karen|Trolan
      steve@homewall.com|Steve|Trolan
      jonscarpa@comcast.net|Jon|Scarpa
      renee.cameto@sri.com|Renee|Cameto
      firedave69@yahoo.com|David|DelCol
      gblake@provident.com|Garrett|Blake
      ianmsanford@hotmail.com|Ian|Sanford
      mark@thyerzoo.com|Mark|Thyer
      hfisher09@gmail.com|Heather|Fisher
      scott.jones@gmail.com|Scott|Jones
      sboardpatroller@yahoo.com|Jeffrey|Kumer
      heidimoneil@gmail.com|Heidi|O'Neil
      opulentconcrete@gmail.com|Robert|Lemke
      kevinandheidi@gmail.com|Kevin|Oneil
      b.hubbard@rexmoore.com|Bill|Hubbard
      bailey.liana@gmail.com|Liana|Bailey
      us@thomassherry.com|Tom|Sherry
      lenny.brann@comcast.net|Lenny|Brann
      gregmjoe@sbcglobal.net|Greg|Joe
      laltschuh@gmail.com|Lauren|Altschuh
      fireski911@aol.com|Mike|Fanelli
      austintbennett91@me.com|Austin|Bennett
      calmoore4@yahoo.com|Carrie|Moore
      Skimurse@gmail.com|Ryan|Sweet
      wsheek@gmail.com|Wayne|Sheek
      bj-hastings@prodigy.net|Beverlee|Hastings
      wolhiser@silverhawktech.com|Wayne|Olhiser
      nathan.gosink@rexmoore.com|Nathan|Gosink
      trojan_71_football@yahoo.com|Jacob|Moss
      michael.t.middleton@gmail.com|Michael|Middleton
      rjnoyes@gmail.com|Rob|Noyes
      mike@peakinspiration.com|Mike|Welch
      mjehenson@gmail.com|Michele|Jehenson
      trozzi@gmail.com|Tony|Rozzi
      palmsart@mac.com|Todd|Popple
      patrickellis42@rocketmail.com|Patrick|Ellis
      sjoparsons@yahoo.com|Stephanie|Parsons
      tracy@cal.net|Mike|Tracy
      mikepass@sunset.net|Mike|Passovoy
      fphilpot@vailresorts.com|Forrest|Philpot
      legay@sbcglobal.net|Mike|Legay
      susanaortiz8@gmail.com|Susana|Ortiz
      curtmulkey@hotmail.com|Curtis|Mulkey
      smblean@hotmail.com|Shannon|Blean
      cmjb1@surewest.net|Charlie|Jennings-Bledsoe
      nicole.dooling@gmail.com|Nicole|Dooling
      sholmes@boothcreek.com|Sara|Holmes
      ridepowdernow@hotmail.com|Tyler|Williamson
      ssibillia@vailresorts.com|Scott|Sibillia
      bgodsoe@vailresorts.com|Bill|Godsoe)

    say_with_time "Creating #{users.count} users..." do
      users.each do |user|
        parts = user.split('|')
        say "#{parts[1]} #{parts[2]} (#{parts[0]})", true
        User.create!(email: parts[0], first_name: parts[1], last_name: parts[2])
      end
    end

    User.create!(email: 'marybethsteadman@gmail.com',
                 first_name: 'Mary Beth',
                 last_name: 'Steadman')
  end

  def down
    User.destroy_all
  end
end
