//
//  Money.swift
//  Ordr
//
//  Created by Abraham Jonsonson on 26/11/16.
//  Copyright © 2016 RMITMark Stuart Software. All rights reserved.
//

import Foundation
import CoreData

enum DivisionError: Error {
    case byZero
}

enum MoneyOutOfBoundsError: Error {
    case dollarLessThanZero
    case centLessThanZero
    case centMoreThanNinetyNine
    case unknown
}

class MoneyCoreData: NSManagedObject {
    @NSManaged var sign: Bool
    @NSManaged var dollar: Int
    @NSManaged var cent: Int
    
    func set( _ amount: Money ) {
        self.sign = amount.sign
        self.dollar = amount.dollar
        self.cent = amount.cent
    }
    
    func get() throws -> Money {
        do {
            return try Money( sign: self.sign, dollar: self.dollar, cent: self.cent )
        } catch MoneyOutOfBoundsError.dollarLessThanZero {
            print("Negative dollar amount not allowed")
            throw MoneyOutOfBoundsError.dollarLessThanZero
        } catch MoneyOutOfBoundsError.centLessThanZero {
            print("Negative cent amount not allowed")
            throw MoneyOutOfBoundsError.centLessThanZero
        } catch MoneyOutOfBoundsError.centMoreThanNinetyNine {
            print("Cent amount more than 99")
            throw MoneyOutOfBoundsError.centMoreThanNinetyNine
        } catch {
            print("Unknown error encountered")
            throw MoneyOutOfBoundsError.unknown
        }
    }
}

class Money {
    var dollar: Int
    var cent: Int
    
    // True indicates positive, False indicates negative.
    var sign: Bool
    
    init ( sign: Bool, dollar: Int, cent: Int ) throws {
        guard dollar >= 0 else {
            print(dollar)
            throw MoneyOutOfBoundsError.dollarLessThanZero
        }
        
        guard cent >= 0 else {
            throw MoneyOutOfBoundsError.centLessThanZero
        }
        
        guard cent < 100 else {
            throw MoneyOutOfBoundsError.centMoreThanNinetyNine
        }
        
        self.sign = sign
        self.dollar = dollar
        self.cent = cent
        
        if( dollar == 0 && cent == 0 && sign == false ) {
            self.sign = true
        }
    }
    
    init ( dollar: Int, cent: Int ) throws {
        guard dollar >= 0 else {
            throw MoneyOutOfBoundsError.dollarLessThanZero
        }
        
        guard cent >= 0 else {
            throw MoneyOutOfBoundsError.centLessThanZero
        }
        
        guard cent < 100 else {
            throw MoneyOutOfBoundsError.centMoreThanNinetyNine
        }
        
        self.sign = true
        self.dollar = dollar
        self.cent = cent
    }
    
    init ( dollar: Int ) throws {
        guard dollar >= 0 else {
            throw MoneyOutOfBoundsError.dollarLessThanZero
        }
        
        self.sign = true
        self.dollar = dollar
        self.cent = 0
    }
    
    init ( cent: Int ) throws {
        guard cent >= 0 else {
            throw MoneyOutOfBoundsError.centLessThanZero
        }
        
        guard cent < 100 else {
            throw MoneyOutOfBoundsError.centMoreThanNinetyNine
        }
        
        self.sign = true
        self.dollar = 0
        self.cent = cent
    }
    
    init ( amount: Float ) {
        let moneyParts = modf( amount )
        self.dollar = Int( moneyParts.0 )
        self.cent = Int( moneyParts.1 * 100 )
        
        // Find sign.
        if ( amount < 0 ) {
            self.sign = false
            self.dollar = abs( self.dollar )
            self.cent = abs( self.cent )
        } else {
            self.sign = true
        }
    }
    
    func string() -> String {
        var sign = ""
        if ( self.sign == false ) {
            sign = "-"
        }
        return String( format: "%@%d.%02d", sign, self.dollar, self.cent )
    }
}

// Addition operator overloader
func +( lhs: Money, rhs: Money ) throws -> Money {
    
    var sign = true
    var dollars = 0
    var cents = 0
    
    switch ( lhs.sign, rhs.sign ) {
    case ( true, true ):
        dollars = lhs.dollar + rhs.dollar
        cents = lhs.cent + rhs.cent
        
        if ( cents > 99 ) {
            cents -= 100
            dollars += 1
        }
        break
    case ( true, false ):
        dollars = lhs.dollar - rhs.dollar
        
        if ( dollars < 0 ) {
            sign = false
            
            if ( lhs.cent > 0 ) {
                dollars += 1
                cents = 100 - lhs.cent
            }
            
            cents += rhs.cent
            if( cents > 100 ) {
                dollars -= 1
                cents -= 100
            }
            
            dollars = abs( dollars )
        } else if ( dollars > 0 ) {
            cents = lhs.cent - rhs.cent
            
            if ( cents < 0 ) {
                cents += 100
                dollars -= 1
            }
        } else {
            cents = lhs.cent - rhs.cent
            
            if ( cents < 0 ) {
                sign = false
                cents = abs( cents )
            }
        }
        break
    case ( false, true ):
        dollars = lhs.dollar - rhs.dollar
        
        if ( dollars > 0 ) {
            sign = false
            
            cents = lhs.cent - rhs.cent
            if ( cents < 0 ) {
                cents += 100
                dollars -= 1
            }
        } else if ( dollars < 0 ) {
            if ( lhs.cent > 0 ) {
                dollars += 1
                cents = 100 - lhs.cent
            }
            
            cents += rhs.cent
            if( cents > 100 ) {
                dollars -= 1
                cents -= 100
            }
            
            dollars = abs( dollars )
        } else {
            cents = lhs.cent - rhs.cent
            
            if ( cents > 0 ) {
                sign = false
            }
            
            cents = abs( cents )
        }
        break
    default:
        // Two negatives
        dollars = lhs.dollar + rhs.dollar
        cents = lhs.cent + rhs.cent
        
        if ( cents > 99 ) {
            cents -= 100
            dollars += 1
        }
        
        sign = false
        break
    }
    
    do {
        return try Money( sign: sign, dollar: dollars, cent: cents )
    } catch MoneyOutOfBoundsError.dollarLessThanZero {
        print("Negative dollar amount not allowed")
        throw MoneyOutOfBoundsError.dollarLessThanZero
    } catch MoneyOutOfBoundsError.centLessThanZero {
        print("Negative cent amount not allowed")
        throw MoneyOutOfBoundsError.centLessThanZero
    } catch MoneyOutOfBoundsError.centMoreThanNinetyNine {
        print("Cent amount more than 99")
        throw MoneyOutOfBoundsError.centMoreThanNinetyNine
    } catch {
        print("Unknown error encountered")
        throw MoneyOutOfBoundsError.unknown
    }
}

// Subtraction operator overloader.
func -( lhs: Money, rhs: Money ) throws -> Money {
    
    var sign = true
    var dollars = 0
    var cents = 0
    
    switch ( lhs.sign, rhs.sign ) {
    case ( true, true ):
        dollars = lhs.dollar - rhs.dollar
        
        if ( dollars < 0 ) {
            sign = false
            
            cents = lhs.cent - rhs.cent
            if ( cents < 0 ) {
                cents = abs( cents )
            } else {
                cents = 100 - cents
                dollars += 1
            }
        } else {
            cents = lhs.cent - rhs.cent
            
            if ( cents < 0 ) {
                if ( dollars == 0 ) {
                    sign = false
                    cents = abs( cents )
                } else {
                    dollars -= 1
                    cents += 100
                }
            }
        }
        break
    case ( true, false ):
        dollars = lhs.dollar + rhs.dollar
        cents = lhs.cent + rhs.cent
        
        if ( cents > 99 ) {
            cents -= 100
            dollars += 1
        }
        break
    case ( false, true ):
        sign = false
        
        dollars = lhs.dollar + rhs.dollar
        cents = lhs.cent + rhs.cent
        
        if ( cents > 99 ) {
            cents -= 100
            dollars += 1
        }
        break
    default:
        // Both sign s are false.
        dollars = lhs.dollar - rhs.dollar
        
        if ( dollars < 0 ) {
            cents = lhs.cent - rhs.cent
            
            if ( cents < 0 ) {
                cents = abs( cents )
            } else {
                cents = 100 - cents
                dollars += 1
            }
            
            dollars = abs( dollars )
        } else if ( dollars > 0 ) {
            sign = false
            
            cents = lhs.cent - rhs.cent
            if ( cents < 0 ) {
                cents = 100 + cents
                dollars -= 1
            }
        } else {
            // dollars = 0
            cents = lhs.cent - rhs.cent
            
            if ( cents < 0 ) {
                cents = abs( cents )
            } else {
                sign = false
            }
        }
        break
    }
    
    do {
        return try Money( sign: sign, dollar: dollars, cent: cents )
    } catch MoneyOutOfBoundsError.dollarLessThanZero {
        print("Negative dollar amount not allowed")
        throw MoneyOutOfBoundsError.dollarLessThanZero
    } catch MoneyOutOfBoundsError.centLessThanZero {
        print("Negative cent amount not allowed")
        throw MoneyOutOfBoundsError.centLessThanZero
    } catch MoneyOutOfBoundsError.centMoreThanNinetyNine {
        print("Cent amount more than 99")
        throw MoneyOutOfBoundsError.centMoreThanNinetyNine
    } catch {
        print("Unknown error encountered")
        throw MoneyOutOfBoundsError.unknown
    }
}

func *( lhs: Money, rhs: Float ) throws -> Money {
    let floatParts = modf( rhs )
        
    let a: Float = Float( lhs.dollar ) * abs( floatParts.0 )
    let b: Float = Float( lhs.dollar ) * abs( floatParts.1 )
    let c: Float = Float( lhs.cent ) / 100 * abs( floatParts.0 )
    let d: Float = Float( lhs.cent ) / 100 * abs( floatParts.1 )
    
    let moneyParts = modf( a + b + c + d )
    let dollars = Int( moneyParts.0 )
    let cents = Int( round( moneyParts.1 * 100 ) )

    var rhsSign = true
    
    if( rhs < 0 ) {
        rhsSign = false
    }
    
    var sign = true
    
    switch ( lhs.sign, rhsSign ) {
    case ( true, false ):
        sign = false
        break
    case ( false, true ):
        sign = false
        break
    default:
        sign = true
        break
    }
    
    do {
        return try Money( sign: sign, dollar: dollars, cent: cents )
    } catch MoneyOutOfBoundsError.dollarLessThanZero {
        print("Negative dollar amount not allowed")
        throw MoneyOutOfBoundsError.dollarLessThanZero
    } catch MoneyOutOfBoundsError.centLessThanZero {
        print("Negative cent amount not allowed")
        throw MoneyOutOfBoundsError.centLessThanZero
    } catch MoneyOutOfBoundsError.centMoreThanNinetyNine {
        print("Cent amount more than 99")
        throw MoneyOutOfBoundsError.centMoreThanNinetyNine
    } catch {
        print("Unknown error encountered")
        throw MoneyOutOfBoundsError.unknown
    }
}

func /( lhs: Money, rhs: Float ) throws -> Money {
    // Protect against dividion by zero.
    guard rhs != 0.0 else {
        print("Cannot divide by zero")
        throw DivisionError.byZero
    }
    
    let left = Float( lhs.dollar ) + ( Float( lhs.cent ) / 100 )
    
    let moneyParts = modf( left / abs( rhs ) )
    let dollars = Int( moneyParts.0 )
    let cents = Int( moneyParts.1 * 100 )
    
    var rhsSign = true
    
    if( rhs < 0 ) {
        rhsSign = false
    }
    
    var sign = true
    
    switch ( lhs.sign, rhsSign ) {
    case ( true, false ):
        sign = false
        break
    case ( false, true ):
        sign = false
        break
    default:
        sign = true
        break
    }
    
    do {
        return try Money( sign: sign, dollar: dollars, cent: cents )
    } catch MoneyOutOfBoundsError.dollarLessThanZero {
        print("Negative dollar amount not allowed")
        throw MoneyOutOfBoundsError.dollarLessThanZero
    } catch MoneyOutOfBoundsError.centLessThanZero {
        print("Negative cent amount not allowed")
        throw MoneyOutOfBoundsError.centLessThanZero
    } catch MoneyOutOfBoundsError.centMoreThanNinetyNine {
        print("Cent amount more than 99")
        throw MoneyOutOfBoundsError.centMoreThanNinetyNine
    } catch {
        print("Unknown error encountered")
        throw MoneyOutOfBoundsError.unknown
    }
}
