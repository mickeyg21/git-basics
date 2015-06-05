//Function Definitions

function displayGreeting()                          //functions should be a verb to describe what it is doing
{
document.write("Hey Dude");

}

function displayPlayerScore(theScore) //the passed value has been name theScore to keep it from being confusing
{
//var playerScore=100; //this is blanked out for variable pass from html code
theScore += 1000; //theScore (which was passed) + 1000)

document.write("<br/> Player Score: " + theScore); //notice that theScore will be passed to the function itself
}

function addTheseNumbers(x,y)
{
document.write(x+y);//because the document.write was placed here it exits here. then runs whatever is next in html page
return(x+y);//to return the value to the caller 
}