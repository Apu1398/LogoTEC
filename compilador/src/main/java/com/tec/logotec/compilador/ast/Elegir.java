package com.tec.logotec.compilador.ast;

import java.util.List;
import java.util.Random;

public class Elegir implements ASTNode {
	
	private List<ASTNode> mathExpressions;
	

	public Elegir(List<ASTNode> mathExpressions) {
		super();
		this.mathExpressions = mathExpressions;
	}

	@Override
	public Object execute(Context symbolTable) {
		Random rand = new Random(); 
		int size = mathExpressions.size();
		int rand_int = rand.nextInt(size);
		return mathExpressions.get(rand_int).execute(symbolTable);
	}

}
