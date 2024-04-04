(define (problem problem1)
  (:domain lucca-underwater-exploration)
  (:objects
    aa - land    
    ab - land    
    ac - land
    ba - shallow-water
    bb - shallow-water
    bc - shallow-water
    ca - deep-water  
    cb - deep-water   
    cc - deep-water
    da - deep-water   
    db - deep-water    
    dc - deep-water
    
    pilot1 - pilot
    pilot2 - pilot
    pilot3 - pilot
    pilot4 - pilot
    scientist1 - scientist
    scientist2 - scientist
    scientist3 - scientist
    scientist4 - scientist
    engineer1 - engineer
    engineer2 - engineer
    engineer3 - engineer
    engineer4 - engineer
    
    sub1 - sub
    sub2 - sub
    
    energy-cable-kit1 - energy-cable-kit
    energy-cable-kit2 - energy-cable-kit
    energy-cable-kit3 - energy-cable-kit
    energy-cable-kit4 - energy-cable-kit
    energy-cable-kit5 - energy-cable-kit
    energy-cable-kit6 - energy-cable-kit
    energy-cable-kit7 - energy-cable-kit
    energy-cable-kit8 - energy-cable-kit
    structure-kit1 - structure-kit
    structure-kit2 - structure-kit
    structure-kit3 - structure-kit
    structure-kit4 - structure-kit
    structure-kit5 - structure-kit
    structure-kit6 - structure-kit
    structure-kit7 - structure-kit
    structure-kit8 - structure-kit
  )
  (:init
  
    (main-base bb)
    
    (at pilot1 bb)
    (at pilot2 bb)
    (at scientist1 bb)
    (at engineer1 bb)
    (at engineer2 bb)
    (at sub1 bb)
    (at sub2 bb)
    (at energy-cable-kit1 bb)
    (at structure-kit1 bb)
    (at structure-kit2 bb)
    (at structure-kit3 bb)
    (at structure-kit4 bb)
    (at structure-kit5 bb)
    
    (adjacent aa ab)
    (adjacent aa ba)
    (adjacent ab aa)
    (adjacent ab bb)
    (adjacent ab ac)
    (adjacent ac ab)
    (adjacent ac bc)

    (adjacent ba aa)
    (adjacent ba bb)
    (adjacent ba ca)
    (adjacent bb ab)
    (adjacent bb bc)
    (adjacent bb cb)
    (adjacent bb ba)
    (adjacent bc ac)
    (adjacent bc bb)
    (adjacent bc cc)

    (adjacent ca ba)
    (adjacent ca cb)
    (adjacent ca da)
    (adjacent cb bb)
    (adjacent cb cc)
    (adjacent cb db)
    (adjacent cb ca)
    (adjacent cc bc)
    (adjacent cc cb)
    (adjacent cc dc)

    (adjacent da ca)
    (adjacent da db)
    (adjacent db da)
    (adjacent db cb)
    (adjacent db dc)
    (adjacent dc db)
    (adjacent dc cc)
    
  )
  (:goal
    (and
        (sonar-array-on)
    )
  )
)