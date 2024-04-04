(define (domain lucca-underwater-exploration)
  (:requirements 
    :strips
    :typing)
  
  ; Define types
  (:types
    location landmarks sub kit personnel scans - object
    land sea - location
    shallow-water deep-water - sea
    kraken - landmarks
    energy-cable-kit structure-kit - kit
    pilot passenger - personnel
    engineer scientist - passenger
    research-scan survey-scan - scans
  )

  ; Define predicates
  (:predicates
    (adjacent ?loc - location ?adjloc - location) ; Location ?loc is adjacent to location ?adjloc.
    (at ?x - object ?loc - location) ; Object ?x is at location ?loc.
    (on-board ?p - personnel ?s - sub) ; Personnel ?p is on sub ?s.
    (in-cargo ?k - kit ?s - sub) ; Sub ?s is carrying kit ?k.
    (sub-has-scan ?loc - location ?s - sub) ; object ?s is carrying scans for location ?loc.
    (base-has-scan ?scanloc - location ?loc - location) ; underwater-base ?loc is carrying scans for location ?scanloc.
    (analyzed ?loc - location) ; location ?loc has been researched and analyzed.
    (has-pilot ?s - sub) ; Sub ?s has a pilot.
    (has-passenger ?s - sub) ; Sub ?s has a passenger (either a scientist or engineer).
    (has-cargo ?s - sub) ; Sub ?s has a kit in cargo.
    (surveyed ?loc - location) ; location has been surveyed for building.
    (researched ?loc - location) ; location has been surveyed for research.
    (marine-protected ?loc - location) ; Things cannot be built here.
    (has-generator ?loc - location) ; location has an offshore tidal power generator.
    (has-cable ?loc - location) ; location has an offshore energy cable.
    (main-base ?loc - location) ; main base is at location.
    (underwater-base ?loc - location) ; location has an underwater research base.
    (kraken-at ?loc - location) ; kraken is present at location.
    (sonar-array-on) ; Sonar array is turned on.
    (energy-shield-on ?s - sub) ; Sub's energy shield is on.
  )

  ; Define actions
  (:action move
    :parameters (?s - sub 
                ?from - sea
                ?to - sea)
    :precondition 
        (and
            (at ?s ?from)
            (adjacent ?from ?to)
            (or ; Sonar Array is on, or there are no Krakens.
                (sonar-array-on)
                (and
                    (not
                        (kraken-at ?from))
                    (not
                        (kraken-at ?to))))
            (has-pilot ?s)
        )
    :effect 
        (and ; Energy Shield not Toggled. Either Stays on or Stays off.
            (not 
                (at ?s ?from))
            (at ?s ?to)
        )
  )
  
  (:action move-from-kraken
    :parameters 
        (?s - sub 
        ?from - sea
        ?to - sea)
    :precondition 
        (and
            (at ?s ?from)
            (adjacent ?from ?to)
            (and ; A Kraken is there, and the sonar array is off.
                (kraken-at ?from)
                (not
                    (sonar-array-on)))
            (or ; Either a Kraken there (and the sonar array is on) or there isn't a Kraken there.
                (sonar-array-on)
                (not 
                    (kraken-at ?to)))
            (has-pilot ?s)
        )
    :effect 
        (and 
            (not 
                (at ?s ?from))
            (at ?s ?to)
            (not ; Energy Shield Turned Off
                (energy-shield-on ?s))
        )
  )
  
  (:action move-to-kraken
    :parameters 
        (?s - sub 
        ?from - sea
        ?to - sea)
    :precondition
        (and
            (at ?s ?from)
            (adjacent ?from ?to)
            (or ; Either a Kraken there (and the sonar array is on) or there isn't a Kraken there.
                (sonar-array-on)
                (not 
                    (kraken-at ?from)))
            (and ; A Kraken is there, and the sonar array is off.
                (kraken-at ?to)
                (not
                    (sonar-array-on)))
            (has-pilot ?s)
        )
    :effect 
        (and 
            (not 
                (at ?s ?from))
            (at ?s ?to)
            (energy-shield-on ?s) ; Energy Shield Turned on
        )
  )
  
  (:action load-pilot
  :parameters 
        (?loc - location
        ?s - sub
        ?p - pilot)
    :precondition
        (and
            (or ; The Sub is either at base or underwater-base.
                (main-base ?loc)
                (underwater-base ?loc))
            (at ?s ?loc)
            (at ?p ?loc)
            (not ; The sub doesn't have a pilot.
                (has-pilot ?s))
        )
    :effect 
        (and
            (on-board ?p ?s)
            (not
                (at ?p ?loc))
            (has-pilot ?s)
        )
  )
  
  (:action unload-pilot
  :parameters 
        (?loc - location
        ?s - sub
        ?p - pilot)
    :precondition
        (and
            (or ; The Sub is either at base or underwater-base.
                (main-base ?loc)
                (underwater-base ?loc))
            (at ?s ?loc)
            (at ?p ?loc)
            (has-pilot ?s) ; The sub has a pilot.
        )
    :effect 
        (and
            (not
                (on-board ?p ?s))
            (at ?p ?loc)
            (not
                (has-pilot ?s))
        )
  )
  
  (:action load-passenger
  :parameters 
        (?loc - location
        ?s - sub
        ?p - passenger)
    :precondition
        (and
            (or ; The Sub is either at base or underwater-base.
                (main-base ?loc)
                (underwater-base ?loc))
            (at ?s ?loc)
            (at ?p ?loc)
            (not ; The sub doesn't have a passenger.
                (has-passenger ?s))
        )
    :effect 
        (and
            (on-board ?p ?s)
            (not
                (at ?p ?loc))
            (has-passenger ?s)
        )
  )
  
  (:action unload-passenger
  :parameters 
        (?loc - location
        ?s - sub
        ?p - passenger)
    :precondition
        (and
            (or ; the Sub is either at base or underwater-base.
                (main-base ?loc)
                (underwater-base ?loc))
            (at ?s ?loc)
            (on-board ?p ?s)
            (has-passenger ?s) ; The sub has a passenger.
        )
    :effect 
        (and
            (not
                (on-board ?p ?s))
            (at ?p ?loc)
            (not
                (has-passenger ?s))
        )
  )
  
  (:action load-kit
    :parameters 
        (?loc - location
        ?s - sub
        ?p - engineer
        ?k - kit)
    :precondition
        (and
            (main-base ?loc) ; The sub can only load kits at main mase.
            (at ?s ?loc)
            (at ?p ?loc)
            (at ?k ?loc)
            (not
                (has-cargo ?s))
        )
    :effect 
        (and
            (not
                (at ?k ?loc))
            (has-cargo ?s)
            (in-cargo ?k ?s)
        )
  )
  
  (:action unload-kit
    :parameters 
        (?loc - location
        ?s - sub
        ?p - engineer
        ?k - kit)
    :precondition
        (and
            (main-base ?loc) ; The sub can only load kits at main mase.
            (at ?s ?loc)
            (at ?p ?loc)
            (in-cargo ?k ?s)
            (has-cargo ?s)
        )
    :effect 
        (and
            (at ?k ?loc)
            (not
                (has-cargo ?s))
            (not
                (in-cargo ?k ?s))
        )
  )
  
  (:action perform-survey-scan
    :parameters 
        (?loc - location
        ?s - sub
        ?p - scientist)
    :precondition
        (and
            (at ?s ?loc)
            (on-board ?p ?s) ; A scientist has to be on board.
            (not
                (surveyed ?loc)) ; Prevents a location from being surveyed infinitely.
        )
    :effect 
        (and
            (surveyed ?loc)
        )
  )
  
  (:action perform-research-scan
    :parameters 
        (?loc - location
        ?s - sub
        ?p - scientist)
    :precondition
        (and
            (at ?s ?loc)
            (on-board ?p ?s) ; A scientist has to be on board.
            (not
                (researched ?loc)) ; Prevents a location from being researched infinitely.
        )
    :effect 
        (and
            (researched ?loc)
            (sub-has-scan ?loc ?s)
        )
  )
  
  (:action build-power-generator
    :parameters 
        (?loc - shallow-water
        ?adjloc - land
        ?s - sub
        ?p - engineer
        ?k - structure-kit)
    :precondition
        (and
            (at ?s ?loc)
            (adjacent ?loc ?adjloc) ; Has to be adjacent to land.
            (on-board ?p ?s) ; An engineer has to be on board.
            (surveyed ?loc) ; The location has to have been surveyed. 
            (in-cargo ?k ?s)
            (not ; The location cannot be marine protected.
                (marine-protected ?loc))
            (not ; Prevents a location from having INFINITE POWER!!!!
                (has-generator ?loc))
            (not ; Power generators cannot be built on cables.
                (has-cable ?loc))
        )
    :effect 
        (and
            (has-generator ?loc)
            (not
                (in-cargo ?k ?s))
            (not
                (has-cargo ?s))
        )
  )
  
  (:action build-cable
    :parameters 
        (?loc - location
        ?adjloc - location
        ?s - sub
        ?p - engineer
        ?k - energy-cable-kit)
    :precondition
        (and
            (at ?s ?loc)
            (adjacent ?loc ?adjloc) 
            (or ; Has to be adjacent a location with a generator or cable.
                (has-generator ?adjloc)
                (has-cable ?adjloc))
            (on-board ?p ?s) ; An engineer has to be on board.
            (surveyed ?loc) ; The location has to have been surveyed. 
            (in-cargo ?k ?s)
            (not ; The location cannot be marine protected.
                (marine-protected ?loc))
            (not ; Cables cannot be built on power generators.
                (has-generator ?loc))
            (not ; Prevents a location from having infinite cables.
                (has-cable ?loc)) 
        )
    :effect 
        (and
            (has-cable ?loc)
        )
  )
  
  (:action build-underwater-research-base
    :parameters 
        (?loc - deep-water
        ?s1 - sub
        ?s2 - sub
        ?p1 - engineer
        ?p2 - engineer
        ?k1 - structure-kit
        ?k2 - structure-kit)
    :precondition
        (and ; There need to be different 2 subs, with the same kits & personnel.
            (at ?s1 ?loc)
            (at ?s2 ?loc)
            (on-board ?p1 ?s1)
            (on-board ?p2 ?s2)
            (in-cargo ?k1 ?s1)
            (in-cargo ?k2 ?s2)
            (not
                (= ?s1 ?s2))
            (has-cable ?loc) ; Cable needs to be present.
            (not ; Power stations & main base cannot be built in deep-water. No need to specify here.
                (underwater-base ?loc)) ; Cannot build one base on top of another.
        )
    :effect 
        (and
            (not
                (in-cargo ?k1 ?s1))
            (not
                (in-cargo ?k2 ?s2))
            (not
                (has-cargo ?s1))
            (not
                (has-cargo ?s2))
            (underwater-base ?loc)
        )
  )
  
  (:action transfer-scan-to-underwater-base
    :parameters 
        (?loc - location
        ?scanloc - location
        ?s - sub)
    :precondition
        (and
            (underwater-base ?loc) ; There needs to be an underwater-base at the location.
            (at ?s ?loc) ; Sub needs to be present at base to transfer data.
            (sub-has-scan ?scanloc ?s)
            (not
                (base-has-scan ?scanloc ?loc))
        )
    :effect 
        (and
            (not
                (sub-has-scan ?scanloc ?s))
            (base-has-scan ?scanloc ?loc)
        )
  )
  
  (:action analyze-scan
    :parameters 
        (?loc - location
        ?scanloc - location
        ?p - scientist)
    :precondition
        (and
            (underwater-base ?loc)
            (at ?p ?loc) ; A scientist needs to be present.
            (base-has-scan ?scanloc ?loc)
            (not
                (analyzed ?scanloc)) ; Prevents infinite loop of location being analyzed.
        )
    :effect 
        (and
            (not
                (base-has-scan ?scanloc ?loc))
            (analyzed ?scanloc)
        )
  )
  
  (:action activate-sonar-array
    :parameters 
        (?loc1 - location
        ?loc2 - location
        ?p - scientist)
    :precondition
        (and
            (underwater-base ?loc1) ; Needs 2 underwater bases.
            (underwater-base ?loc2)
            (not
                (= ?loc1 ?loc2))
            (at ?p ?loc1) ; Scientist only needs to be present at 1 underwater base.
            (not
                (sonar-array-on))
        )
    :effect 
        (and
            (sonar-array-on)
        )
  )

)