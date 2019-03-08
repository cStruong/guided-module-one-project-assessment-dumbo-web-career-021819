Passenger.destroy_all
Driver.destroy_all
Trip.destroy_all


#Passengers
chris = Passenger.create(name: "Chris", phone: 1234567890)
alonzo = Passenger.create(name: "Alonzo" , phone: 2345678901)
kobe = Passenger.create(name: "Kobe", phone: 3456789012)
michael = Passenger.create(name: "Michael", phone: 4567890123)
steve = Passenger.create(name: "Steve", phone: 5678901234)
kevin = Passenger.create(name: "Kevin", phone: 6789012345)
kristaps = Passenger.create(name: "Kristaps", phone: 7890123456)
stephen = Passenger.create(name: "Stephen", phone: 8901234567)
lebron = Passenger.create(name: "LeBron", phone: 9012345678)
allen = Passenger.create(name: "Allen", phone: 1234567820)

#Drivers
brianoconner = Driver.create(name: "Brian O'Conner", plates: "2NAN0CRU57", company: "Uber")
dominictoretto = Driver.create(name: "Dominic Toretto", plates: "F4M1LY", company: "Uber")
johnnytran = Driver.create(name: "Johnny Tran", plates: "2SOONJUNI0R", company: "Lyft")
romanpearce = Driver.create(name: "Roman Pearce", plates: "EJ3CT0SE4T0", company: "Uber")
hanlue = Driver.create(name: "Han Lue", plates: "D0NTL00KB4CK", company: "Uber")
takashi = Driver.create(name: "Takashi", plates: "IAMDK", company: "Uber")
bowwow = Driver.create(name: "Bow Wow", plates: "D4HULK", company: "Uber")
seanboswell = Driver.create(name: "Sean Boswell", plates: "1TSD4R1D3R", company: "Uber")
frankmartin = Driver.create(name: "Frank Martin", plates: "D4TRANSP0RTER", company: "Private")
bobschmoe = Driver.create(name: "Bob Schmoe", plates: "IMJU57N0RMAL", company: "Lyft")

#Trips
Trip.create(passenger_id: chris.id, driver_id: johnnytran.id, trip_rating: 2)
Trip.create(passenger_id: kobe.id, driver_id: johnnytran.id, trip_rating: 5)
Trip.create(passenger_id: kevin.id, driver_id: hanlue.id, trip_rating: 3)
Trip.create(passenger_id: steve.id, driver_id: brianoconner.id, trip_rating: 5)
Trip.create(passenger_id: allen.id, driver_id: dominictoretto.id, trip_rating: 4)
Trip.create(passenger_id: kristaps.id, driver_id: seanboswell.id, trip_rating: 2)
Trip.create(passenger_id: alonzo.id, driver_id: bowwow.id, trip_rating: 5)
Trip.create(passenger_id: stephen.id, driver_id: takashi.id, trip_rating: 5)
Trip.create(passenger_id: lebron.id, driver_id: frankmartin.id, trip_rating: 1)
Trip.create(passenger_id: michael.id, driver_id: bobschmoe.id, trip_rating: 2)
Trip.create(passenger_id: chris.id, driver_id: brianoconner.id, trip_rating: 4)
