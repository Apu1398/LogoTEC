package com.tec.logotec.compilador.ast;

import java.util.List;

public class Repite implements ASTNode {


	private int numberCondition;
	private List<ASTNode> body;
	
	
	public Repite(int numberCondition , List<ASTNode> body) {
		super();
		this.numberCondition = numberCondition;
		this.body = body;
	}


	@Override
	public Object execute(Context symbolTable) {
		while( 0 < numberCondition) {
			for (ASTNode statement : body) {
				statement.execute(symbolTable);
			}
			numberCondition--;
		}
		return null;
	}

}
