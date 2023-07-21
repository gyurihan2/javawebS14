<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
	#theaterSeatList {
	    background-color: #242333;
	    color: #fff;
	    display: flex;
	    flex-direction: column;
	    align-items: center;
	    justify-content: center;
	    font-family: 'Lato', sans-serif;
	    margin: 0;
	}
	
	.movie-container {
	    margin: 20px 0;
	}
	
	.movie-container select {
	    background-color: #fff;
	    border: 0;
	    border-radius: 5px;
	    font-size: 14px;
	    margin-left: 10px;
	    padding: 5px 15px 5px 15px;
	    -moz-appearance: none;
	    -webkit-appearance: none;
	    appearance: none;
	}
	
	.container {
	    perspective: 1000px;
	    margin-bottom: 30px;
	}
	
	.seat {
	    background-color: #444451;
	    height: 15px;
	    width: 20px;
	    margin: 3px;
	    border-top-left-radius: 10px;
	    border-top-right-radius: 10px;
	}
	
	.seat.selected {
	    background-color: #6feaf6;
	}
	
	.seat.occupied {
	    background-color: #fff;
	}
	
	.seat:nth-of-type(5) {
	    margin-right: 18px;
	}
	
	.seat:nth-last-of-type(5) {
	    margin-left: 18px;
	}
	
	.seat:not(.occupied):hover {
	    cursor: pointer;
	    transform: scale(1.2);
	}
	
	.showcase .seat:not(.occupied):hover {
	    cursor: default;
	    transform: scale(1);
	}
	
	.showcase {
	    background: rgba(0, 0, 0, 0.1);
	    padding: 5px 10px;
	    border-radius: 5px;
	    color: #777;
	    list-style-type: none;
	    display: flex;
	    justify-content: space-between;
	}
	
	.showcase li {
	    display: flex;
	    align-items: center;
	    justify-content: center;
	    margin: 0 10px;
	}
	
	.showcase li small {
	    margin-left: 2px;
	}
	
	.row {
	    display: flex;
	}
	
	.screen {
	    background-color: #fff;
	    height: 70px;
	    width: 100%;
	    margin: 15px 0;
	    transform: rotateX(-45deg);
	    box-shadow: 0 3px 10px rgba(255, 255, 255, 0.7);
	}
	
	p.text {
	    margin: 5px 0;
	}
	
	p.text span {
	    color: #6feaf6;
	}
</style>
<script>
	
	/* $(function(){
	  const container = document.querySelector('.theaterSeat');
	  // Seat click event
	  container.addEventListener('click', e => {
		  if (e.target.classList.contains('seat') && !e.target.classList.contains('occupied')) 
		  {
			  console.log(e.target.classList.id);
	      e.target.classList.toggle('selected');
	  	}
	  });
	}); */
</script>        