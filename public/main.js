var minAge = 18;
var today = new Date()
//Calculates age from given Birth Date in the form//
function _calcAge(birthDate, givenDate) {
  givenDate = new Date(today);
  var dt1 = document.getElementById('date').value;
  var birthDate = new Date(dt1);
  var years = (givenDate.getFullYear() - birthDate.getFullYear());

  if (givenDate.getMonth() < birthDate.getMonth() ||
  givenDate.getMonth() == birthDate.getMonth() && givenDate.getDate() < birthDate.getDate()) {
    years--;
  }

  return years;
}

//Compares calculated age with minimum age and acts according to rules//
function _setAge() {

  var age = _calcAge();
  if (age < minAge) {
    alert("You are not allowed into the site. The minimum age is 18!");
  } else

  console.log(" ")


}
