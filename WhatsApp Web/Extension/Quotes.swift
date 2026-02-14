//
//  Quotes.swift
//  WhatsApp Web
//
//  Created by mac on 11/06/24.
//

import Foundation

class Quotes {
    
    func quotes(quoteName: String) -> [String] {
        var arrQuote = [String]()
        
        switch quoteName {
        case "Morning":
            arrQuote = ["Rise up, start fresh, see the bright opportunity in each new day.","Every morning is a chance at a new day filled with endless possibilities.","Each morning we are born again. What we do today matters most.","Good morning! Start your day with a smile and a heart full of gratitude.","Wake up with determination, go to bed with satisfaction."]
        case "Attitude":
            arrQuote = ["Your attitude, not your aptitude, will determine your altitude.","Attitude is a little thing that makes a big difference.","Life is 10% what happens to us and 90% how we react to it.","The only disability in life is a bad attitude.","Never break my trust if you break my trust I will break you"]
        case "Relationship":
            arrQuote = ["Love is not about possession, it's about appreciation.","Trust is the foundation of every successful relationship.","In a strong relationship, two imperfect people learn to enjoy their differences.","True love is not about finding someone perfect; it's about seeing an imperfect person","Communication is the key that unlocks the door to a healthy relationship.","In all the world, there is no heart for me like yours.","A true relationship is two unperfect people refusing to give up on each other.","The best thing to hold onto in life is each other."]
        case "Birthday":
            arrQuote = ["Today you are you! That is truer than true! There is no one alive who is you'r than you!","Age is merely the number of years the world has been enjoying you.","A birthday is just the first day of another 365-day journey around the sun. Enjoy the trip!", "The more you praise and celebrate your life, the more there is in life to celebrate.","May your birthday be filled with sunshine and smiles, laughter, love, and cheer.","Happy birthday to someone who's forever young at heart.","May your birthday be the start of a year filled with good luck, good health, and much happiness."]
        case "Engagement":
            arrQuote = ["Love one another and you will be happy. It's as simple and as difficult as that.","The best and most beautiful things in this world cannot be seen or even heard, but must be felt with the heart.","Love does not consist of gazing at each other, but in looking outward together in the same direction.","A successful marriage requires falling in love many times, always with the same person.","Two souls with but a single thought, two hearts that beat as one.","Wishing you both a lifetime of love and happiness together. Congratulations on your","A perfect match made in heaven. Congratulations on your engagement!"]
        case "Parents":
            arrQuote = ["A father is neither an anchor to hold us back nor a sail to take us there, but a guiding light whose love shows us the way.","A truly rich man is one whose children run into his arms when his hands are empty.","A father is someone you look up to, no matter how tall you grow.","A mother's love is the fuel that enables a normal human being to do the impossible.","A Parent’s love is like a beacon, guiding us through the darkest moments of life.","To the world, you may be one person, but to one person you may be the world.","The most precious jewels you'll ever have around your neck are the arms of your children.","Being a parent means loving your children more than you've ever loved yourself."]
        case "Anniversary":
            arrQuote = ["In all the world, there is no heart for me like yours. In all the world, there is no love for you like mine.","The best thing to hold onto in life is each other.","You are my today and all of my tomorrows.","The secret of a happy marriage is finding the right person. You know they're right if you love to be with them all the time.","Grow old with me, the best is yet to be.","Every love story is beautiful, but ours is my favorite.","Our anniversary is a reminder of how far we've come and how much we have to look forward to."]
        default :
            break
        }
        
        return arrQuote
    }
}
