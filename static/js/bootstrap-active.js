/*menu handler*/
$(function(){
 var url = window.location.pathname;  
 var activePage = url.substring(url.lastIndexOf('/')+1);
$('.nav li a').each(function(){  
var currentPage = this.href.substring(this.href.lastIndexOf('/')+1);

if (activePage == currentPage) {
$(this).parent().addClass('active'); 
} 
});
 })
