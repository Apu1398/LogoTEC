package com.tec.logotec.compilador.ast;

import java.util.List;

public class Loop implements ASTNode {

	private ASTNode condition;
	private List<ASTNode> body;
	
	
	public Loop(ASTNode condition, List<ASTNode> body) {
		super();
		this.condition = condition;
		this.body = body;
	}


	@Override
	public Object execute() {
		while((boolean)condition.execute()) {
			for (ASTNode statement : body) {
				statement.execute();
			}
		}
		return null;
	}

}
