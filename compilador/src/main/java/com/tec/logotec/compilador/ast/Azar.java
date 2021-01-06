package com.tec.logotec.compilador.ast;
import java.util.Random; 

public class Azar implements ASTNode {

	
	private ASTNode topValue;
	
	
	public Azar(ASTNode topValue) {
		super();
		this.topValue = topValue;
		
	}
	
	@Override
	public Object execute(Context symbolTable) {
		Random rand = new Random();  
        int rand_int = rand.nextInt((int)topValue.execute(symbolTable));
		return rand_int;
	}

}
